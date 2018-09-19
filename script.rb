require './twitter_analytics_client'
require './google_sheet_client'
require './twitter_account'

spreadsheet_url = ENV['SPREADSHEET_URL']

TwitterAccount.all.each do |twitter_user|
  analytics_client = TwitterAnalyticsClient.new(twitter_user)
  csv = analytics_client.get_analytics_data_with_cookies
  csv = analytics_client.get_analytics_data_with_login unless csv
  sheet_client = GoogleSheetClient.new(spreadsheet_url)
  sheet_client.write_in_spreadsheet(csv, twitter_user["worksheet_name"])
end
