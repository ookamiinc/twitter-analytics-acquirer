require 'mechanize'
require 'rails'
require './twitter_account'

class TwitterAnalyticsClient
  BASE_URI = 'https://twitter.com'.freeze
  ANALYTICS_URI = 'https://analytics.twitter.com/user'.freeze

  def initialize(twitter_account)
    @account = twitter_account
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Mac Mozilla'
  end

  def get_analytics_data_with_cookies
    return unless @account["cookies"]
    set_cookies(@account["cookies"])
    get_analytics_data
  end

  def set_cookies(cookies_yaml)
    cookies_io_read = StringIO.new(cookies_yaml, 'r')
    @agent.cookie_jar.clear
    @agent.cookie_jar.load(cookies_io_read)
  end

  def get_analytics_data
    return if @agent.nil?
    @agent.post(export_url)
    for i in 1..10 do
      res = @agent.get(bundle_url)
      break unless res.body.empty?
      sleep(5)
    end
    res.body.force_encoding('utf-8')
  end

  def get_analytics_data_with_login
    login
    csv = get_analytics_data
    save_cookies if csv
    csv
  end

  def login
    page = @agent.get(BASE_URI)
    form = page.forms[1]
    form.field_with(name: "session[username_or_email]").value = @account["name"]
    form.field_with(name: "session[password]").value = @account["password"]
    form.submit
  end

  def save_cookies
    TwitterAccount.update('cookies', cookies_to_yaml_string, @account["id"])
  end


  def cookies_to_yaml_string
    cookies_io_write = StringIO.new("", 'r+')
    @agent.cookie_jar.save(cookies_io_write, {:session => true})
    cookies_io_write.string
  end

  private

  def start_date
    @start_date ||= ( Time.now.utc.beginning_of_month).to_i.to_s + "000"
  end

  def end_date
    @end_date ||= (Time.now.utc).to_i.to_s + "999"
  end

  def export_url
    "#{ANALYTICS_URI}/#{@account["name"]}/tweets/export.json?start_time=#{start_date}&end_time=#{end_date}&lang=ja"
  end

  def bundle_url
    "#{ANALYTICS_URI}/#{@account["name"]}/tweets/bundle?start_time=#{start_date}&end_time=#{end_date}&lang=ja"
  end
end
