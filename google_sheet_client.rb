require 'csv'
require "googleauth"
require "google_drive"
require 'byebug'

class GoogleSheetClient
  def initialize(url)
    @url = url
    start_session_with_auth
  end

  def write_in_spreadsheet(csv, worksheet_name)
    worksheet = worksheet(worksheet_name)
    i = 1
    CSV.parse(csv).each do |row|
      j = 1
      for j in 1..40 do
        worksheet[i,j] = row[j - 1]
      end
      i += 1
    end
    worksheet.save
  end

  private

  def start_session_with_auth
    credentials = Google::Auth::UserRefreshCredentials.new(
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      scope: [
        "https://www.googleapis.com/auth/drive",
        "https://spreadsheets.google.com/feeds/",
      ],
      refresh_token: ENV['GOOGLE_REFRESH_TOKEN'])
    @session = GoogleDrive::Session.from_credentials(credentials)
  end

  def worksheet(name)
    spreadsheet = @session.spreadsheet_by_url(@url)
    spreadsheet.worksheet_by_title(name)
  end
end
