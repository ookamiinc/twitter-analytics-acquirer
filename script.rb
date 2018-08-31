require 'csv'
require "googleauth"
require "google_drive"
require 'mechanize'
require 'rails'
require 'byebug'

require './google_data_sender'
require './twitter_acquier'

id_array = [ENV['TWITTER_ID']]

id_array.each do |id|

  pass, spreadsheet_url = ENV['TWITTER_PASS'], ENV['SPREADSHEET_URL'] if id == ENV['TWITTER_ID']

  agent = Mechanize.new
  scraper = TwitterScraper.new
  scraper.login_to_twitter(agent, id, pass)
  export_url, bundle_url = scraper.set_scraping_url(id)
  analytics_data = scraper.obtain_analytics_data(agent, export_url, bundle_url)
  data_sender = GoogleDataSender.new
  session = data_sender.session_to_google_auth
  spreadsheet = session.spreadsheet_by_url(spreadsheet_url)
  sheet = spreadsheet.worksheet_by_title("test_volley")
  data_sender.send_data_to_spreadsheet(analytics_data, sheet)
end
