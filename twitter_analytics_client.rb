require 'mechanize'
require 'rails'
require './twitter_accounts'

class TwitterAnalyticsClient
  BASE_URI = 'https://twitter.com'.freeze
  ANALYTICS_URI = 'https://analytics.twitter.com/user'.freeze

  def initialize(user, password)
    @user = user
    @password = password
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Mac Mozilla'
  end

  def login
    page = @agent.get(BASE_URI)
    form = page.forms[1]
    form.field_with(name: "session[username_or_email]").value = @user
    form.field_with(name: "session[password]").value = @password
    form.submit
  end

  def save_cookies
    TwitterAccounts.create_or_update(name: "#{@user}", cookies: cookies_to_yaml_string)
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

  def cookies_to_yaml_string
    cookies_io_write = StringIO.new("", 'r+')
    @agent.cookie_jar.save(cookies_io_write, {:session => true})
    cookies_io_write.string
  end

  def set_cookies(cookies_yaml)
    cookies_io_read = StringIO.new(cookies_yaml, 'r')
    @agent.cookie_jar.clear
    @agent.cookie_jar.load(cookies_io_read)
  end

  private

  def start_date
    @start_date ||= ( Time.now.utc.beginning_of_month).to_i.to_s + "000"
  end

  def end_date
    @end_date ||= (Time.now.utc).to_i.to_s + "999"
  end

  def export_url
    "#{ANALYTICS_URI}/#{@user}/tweets/export.json?start_time=#{start_date}&end_time=#{end_date}&lang=ja"
  end

  def bundle_url
    "#{ANALYTICS_URI}/#{@user}/tweets/bundle?start_time=#{start_date}&end_time=#{end_date}&lang=ja"
  end
end
