require 'csv'
require "googleauth"
require "google_drive"
require 'mechanize'
require 'rails'
require 'byebug'


id_array = [ENV['TWITTER_ID']]

id_array.each do |id|

  pass, sp_url = ENV['TWITTER_PASS'], ENV['SPREADSHEET_URL'] if id == ENV['TWITTER_ID']

  start_date = (Time.now.beginning_of_month).to_i.to_s + "000"
  end_date = (Time.now).to_i.to_s + "999"
  agent = Mechanize.new
  page = agent.get('https://twitter.com/')
  form = page.forms[1]
  form.field_with(name: "session[username_or_email]").value = id
  form.field_with(name: "session[password]").value = pass
  form.submit
  export_url = "https://analytics.twitter.com/user/" + id + "/tweets/export.json?start_time=" + start_date + "&end_time=" + end_date + "&lang=ja"
  bundle_url = "https://analytics.twitter.com/user/" + id + "/tweets/bundle?start_time=" + start_date + "&end_time=" + end_date + "&lang=ja"
  agent.post(export_url)
  file = agent.get(bundle_url)
  file.save
  analytics_file = File.read(file.filename)
  credentials = Google::Auth::UserRefreshCredentials.new(
    client_id: ENV['GOOGLE_CLIENT_ID'],
    client_secret: ENV['GOOGLE_CLIENT_SECRET'],
    scope: [
      "https://www.googleapis.com/auth/drive",
      "https://spreadsheets.google.com/feeds/",
    ],
    refresh_token: ENV['GOOGLE_REFRESH_TOKEN'])
  session = GoogleDrive::Session.from_credentials(credentials)
  sp = session.spreadsheet_by_url(sp_url)
  ws = sp.worksheet_by_title("test_volley")
  # CSVをパースし、１行目の１列目から順に埋めていく。
  i = 1
  CSV.parse(analytics_file).each do |csv|
    a = 1
    for a in 1..40 do
      ws[i,a] =csv[a-1]
    end
    i += 1
  end
  puts 'success' if ws.save
  File.delete(file.filename)
end
