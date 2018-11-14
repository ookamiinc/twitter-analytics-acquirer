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
    get_analytics_data(start_date: variable_start_date , end_date: now)
  end

  def get_analytics_data_with_login
    login
    csv = get_analytics_data(start_date: variable_start_date , end_date: now)
    save_cookies if csv
    csv
  end

  def get_cached_line_length
    start_date = variable_boundary_date(former_period = 2)
    end_date = variable_boundary_date(former_period = 1)
    csv = get_analytics_data(start_date: start_date , end_date: end_date)
    save_length(csv.length)
  end

  def save_length(length)
    DatabaseClient.update('stored_csv_length', length, @account['id'])
  end

  private

  def variable_start_date
    return month_beggining if Time.now.strftime('%d').to_i < 11
    variable_boundary_date
  end

  def variable_boundary_date(former_period = 0)
    day_now = Time.now.strftime('%d').to_i
    start_day = 5 * (day_now.div(5) - 1 - former_period)
    month = Time.now.strftime('%m').to_i
    @variable_boundary_date ||= Time.parse("#{month}/#{start_day}").to_i.to_s + '000'
  end

  def month_beggining
    month = Time.now.strftime('%m').to_i
    @month_beggining ||= Time.parse("#{month}/1").to_i.to_s + '000'
  end

  def now
    @now ||= Time.now.utc.to_i.to_s + '999'
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

  def get_analytics_data(start_date: start_date , end_date: end_date)
    return if @agent.nil?

    for i in 1..50 do
      #puts 'post送る前!!============================'
      #puts ''
      export_url = make_export_url(start_date, end_date)
      pos = @agent.post(export_url)
      #@logger.debug(pos)
      #puts 'post送った後============================'
      #puts ''
      bundle_url = make_bundle_url(start_date, end_date)
      res = @agent.get(bundle_url)
      #@logger.debug(res)
      #puts 'get送った後============================'
      #puts ''
      puts 'nil!!' if res.body.empty?
      sleep(5)
      puts i unless res.body.empty?
      puts 'タイトルだけ！' if res.body.count(',') == 39
      break unless res.body.empty?
    end
    res.body.force_encoding('utf-8')
  end

  def make_export_url(start_date, end_date)
    "#{ANALYTICS_URI}/#{@account['name'].downcase}/tweets/export.json?start_time=#{start_date}&end_time=#{end_date}&lang=ja"
  end

  def make_bundle_url(start_date, end_date)
    "#{ANALYTICS_URI}/#{@account['name'].downcase}/tweets/bundle?start_time=#{start_date}&end_time=#{end_date}&lang=ja"
  end
end
