class TestsController < ActionController::Base
  require 'csv'
  require 'mechanize'
  require 'time'

  protect_from_forgery with: :exception

  def home
    start_date = (Time.now).to_i.to_s + "000"
    end_date = ((Time.now).to_i - (60 * 60 * 24 * 7)).to_s + "999"
    user = 'handball_japans'
    pass = '0125MISOmiso'
    agent = Mechanize.new
    page = agent.get('https://twitter.com/')
    form = page.forms.second
    form.field_with(name: "session[username_or_email]").value = user
    form.field_with(name: "session[password]").value = pass
    form.submit
    export_url = "https://analytics.twitter.com/user/handball_japans/tweets/export.json?start_time=" + start_date + "&end_time=" + end_date + "&lang=ja"
    bundle_url = "https://analytics.twitter.com/user/handball_japans/tweets/bundle?start_time=" + start_date + "&end_time=" + end_date + "&lang=ja"
    agent.post(export_url)
    file = agent.get(bundle_url)
    file.save
  end
end
