# frozen_string_literal: true

require './twitter_analytics_client'
require './google_sheet_client'
require './database_client'

spreadsheet_url = ENV['SPREADSHEET_URL']

DatabaseClient.all.each do |twitter_account|
  analytics_client = TwitterAnalyticsClient.new(twitter_account)
  csv = analytics_client.get_analytics_data_with_cookies
  csv ||= analytics_client.get_analytics_data_with_login
  followers_count = analytics_client.followers_count
  sheet_client = GoogleSheetClient.new(spreadsheet_url)
  sheet_client.write_in_spreadsheet(csv, followers_count, twitter_account['worksheet_name'])
end
