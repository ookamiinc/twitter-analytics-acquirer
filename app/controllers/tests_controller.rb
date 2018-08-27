class TestsController < ActionController::Base
  require 'csv'
  require "google_drive"
  require 'mechanize'
  require 'time'

  protect_from_forgery with: :exception

  def home
    start_date = ((Time.now).to_i - (60 * 60 * 24 * 28)).to_s + "000"
    end_date = (Time.now).to_i.to_s + "999"
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
    #次の行の処理でエラーが発生する場合あり。原因追求必要。
    #Errno::ENOENT (No such file or directory @ rb_sysopen - bundle.html_start_time=1532917513000&end_time=1535336713999&lang=ja):
    file = agent.get(bundle_url)
    analytics_file = File.read(file.filename)
    session = GoogleDrive::Session.from_config("config.json")
    sp = session.spreadsheet_by_url("https://docs.google.com/spreadsheets/d/1mNAJZp0B0nLZ6dYuoMZuYDmIRUd_w8PiiY_NtEUFTW8/edit#gid=0")
    ws = sp.worksheets[0]
    # CSVをパースし、１行目の１列目から順に埋めていく。
    i = 1
    CSV.parse(analytics_file).each do |csv|
      a = 1
      for a in 1..40 do
        ws[i,a] =csv[a-1]
      end
      i += 1
    end
    ws.save
  end
end
