# frozen_string_literal: true

require 'mechanize'
require './database_client'
require 'byebug'

class TwitterAnalyticsClient
  BASE_URI = 'https://twitter.com'
  ANALYTICS_URI = 'https://analytics.twitter.com/user'

  def initialize(twitter_account)
    @account = twitter_account
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Mac Mozilla'
  end

  def get_analytics_data_with_cookies
    return unless @account['cookies']

    set_cookies(@account['cookies'])
    get_analytics_data
  end

  def get_analytics_data_with_login
    login
    csv = get_analytics_data
    save_cookies if csv
    csv
  end

  private

  def start_date
    month = Time.now.strftime('%m').to_i
    @start_date ||= Time.parse("#{month}/1").to_i.to_s + '000'
  end

  def end_date
    @end_date ||= Time.now.utc.to_i.to_s + '999'
  end

  def export_url
    "#{ANALYTICS_URI}/#{@account['name'].downcase}/tweets/export.json?start_time=#{start_date}&end_time=#{end_date}&lang=ja"
  end

  def bundle_url
    "#{ANALYTICS_URI}/#{@account['name'].downcase}/tweets/bundle?start_time=#{start_date}&end_time=#{end_date}&lang=ja"
  end

  def set_cookies(cookies_yaml)
    cookies_io_read = StringIO.new(cookies_yaml, 'r')
    @agent.cookie_jar.clear
    @agent.cookie_jar.load(cookies_io_read)
  end

  def cookies_to_yaml_string
    cookies_io_write = StringIO.new(+'', 'r+')
    @agent.cookie_jar.save(cookies_io_write, session: true)
    cookies_io_write.string
  end

  def save_cookies
    DatabaseClient.update('cookies', cookies_to_yaml_string, @account['id'])
  end

  def login
    page = @agent.get(BASE_URI)
    form = page.forms[1]
    form.field_with(name: 'session[username_or_email]').value = @account['name']
    form.field_with(name: 'session[password]').value = @account['password']
    form.submit
  end

  def get_analytics_data
    return if @agent.nil?
    logger = Logger.new(STDERR)
    logger.debug(@agent.inspect)

    for i in 1..20 do
      @agent.post(export_url)
      break if @agent.post(export_url).body.include?("Available")
      sleep(5)
    end
    logger.debug(@agent.inspect)
    for i in 1..10 do
      res = @agent.get(bundle_url)
      puts 'nil!!' if res.body.empty?
      break unless res.body.empty?
    end
    logger.debug(@agent.inspect)
    res.body.force_encoding('utf-8')
  end
end
