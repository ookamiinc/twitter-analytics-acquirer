require './twitter_analytics_client'
require './google_sheet_client'

spreadsheet_url = ENV['SPREADSHEET_URL']
twitter_users = [ENV['TWITTER_ID'],ENV['TWITTER_ID2']]

twitter_users.each do |twitter_user|
  if twitter_user == ENV['TWITTER_ID1']
    twitter_password = ENV['TWITTER_PASS1']
    worksheet_name = ENV['WORKSHEET_NAME']
  elsif twitter_user == ENV['TWITTER_ID2']
    twitter_password = ENV['TWITTER_PASS2']
    worksheet_name = ENV['WORKSHEET_NAME2']
  end
  analytics_client = TwitterAnalyticsClient.new(twitter_user, twitter_password)
  analytics_client.login
  csv = analytics_client.get_analytics_data

  sheet_client = GoogleSheetClient.new(spreadsheet_url)
  sheet_client.write_in_spreadsheet(csv, worksheet_name)
end
