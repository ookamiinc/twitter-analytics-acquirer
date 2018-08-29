require 'csv'
require "googleauth"
require "google_drive"
require 'mechanize'
require 'rails'
require 'byebug'

require './mechanize'
require './twitter_acquier'

id_array = [ENV['TWITTER_ID']]

id_array.each do |id|

  pass, sp_url = ENV['TWITTER_PASS'], ENV['SPREADSHEET_URL'] if id == ENV['TWITTER_ID']

  agent = Mechanize.new
  agent.hello
  agent.login_to_twitter(id, pass)
  acquirer = TwitterAcquier.new
  export_url, bundle_url = acquirer.sending_url(id)
  file = acquirer.obtain_data_file(agent, export_url, bundle_url)
  analytics_file = File.read(file.filename)
  session = acquirer.session_to_google_auth
  sp = session.spreadsheet_by_url(sp_url)
  ws = sp.worksheet_by_title("test_volley")
  acquirer.send_data_to_sp(analytics_file, ws)
  File.delete(file.filename)
end
