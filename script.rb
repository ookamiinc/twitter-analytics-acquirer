require './twitter_analytics_client'
require './google_sheet_client'
require 'byebug'

twitter_user = ENV['TWITTER_ID']
twitter_password = ENV['TWITTER_PASS']
spreadsheet_url = ENV['SPREADSHEET_URL']
worksheet_name = ENV['WORKSHEET_NAME']
analytics_client = TwitterAnalyticsClient.new(twitter_user, twitter_password)
analytics_client.login
csv = analytics_client.get_analytics_data

sheet_client = GoogleSheetClient.new(spreadsheet_url)
sheet_client.write_in_spreadsheet(csv, worksheet_name)
