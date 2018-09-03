require 'mechanize'
require 'rails'

class TwitterAnalyticsClient
  BASE_URI = 'https://twitter.com'.freeze
  ANALYTICS_URI = 'https://analytics.twitter.com/user'.freeze

  def initialize(user, password)
    @user = user
    @password = password
  end

  def login
    @agent = Mechanize.new
    page = @agent.get(BASE_URI)
    form = page.forms[1]
    form.field_with(name: "session[username_or_email]").value = @user
    form.field_with(name: "session[password]").value = @password
    form.submit
    puts "Logged in Twitter @#{@user} password: #{@password}"
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

  private

  def start_date
    @start_date ||= ( Time.now.beginning_of_month.since(9.hours)).to_i.to_s + "000"
  end

  def end_date
    @end_date ||= (Time.now.since(9.hours)).to_i.to_s + "999"
  end

  def export_url
    "#{ANALYTICS_URI}/#{@user}/tweets/export.json?start_time=#{start_date}&end_time=#{end_date}&lang=ja"
  end

  def bundle_url
    "#{ANALYTICS_URI}/#{@user}/tweets/bundle?start_time=#{start_date}&end_time=#{end_date}&lang=ja"
  end
end
