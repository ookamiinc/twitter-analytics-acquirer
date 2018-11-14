# frozen_string_literal: true

require './twitter_analytics_client'
require './google_sheet_client'
require './database_client'
require 'byebug'

spreadsheet_url = ENV['SPREADSHEET_URL']

DatabaseClient.all.each do |twitter_account|
  analytics_client = TwitterAnalyticsClient.new(twitter_account)
  csv = analytics_client.get_analytics_data_with_cookies
  csv ||= analytics_client.get_analytics_data_with_login
  sheet_client = GoogleSheetClient.new(spreadsheet_url)
  sheet_client.write_in_spreadsheet(csv, twitter_account['worksheet_name'])
  analytics_client.get_cached_line_length #if Time.now.strftime('%d').to_i.div(5) == 1 && Time.now.strftime('%d').to_i.div(5) >= 11
end
