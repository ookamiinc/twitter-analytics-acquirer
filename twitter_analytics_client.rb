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
    @logger = Logger.new(STDERR)
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
    @start_date ||= Time.parse('2018-10-01 00:00:00 +0900').to_i.to_s + '000'
  end

  def end_date
    @end_date ||= Time.parse('2018-10-31 23:00:00 +0900').to_i.to_s + '000'
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

    for i in 1..50 do
      #puts 'post送る前!!============================'
      #puts ''
      pos = @agent.post(export_url)
      #@logger.debug(pos)
      #puts 'post送った後============================'
      #puts ''
      res = @agent.get(bundle_url)
      #@logger.debug(res)
      #puts 'get送った後============================'
      #puts ''
      puts 'nil!!' if res.body.empty?
      sleep(5)
      puts i unless res.body.empty?
      break unless res.body.empty?
    end
    res.body.force_encoding('utf-8')
  end
end
