# frozen_string_literal: true

require 'csv'
require 'googleauth'
require 'google_drive'

class GoogleSheetClient
  def initialize(url)
    @url = url
    start_session_with_auth
  end

  def write_in_spreadsheet(csv, worksheet_name)
    worksheet = worksheet(worksheet_name)
    worksheet.delete_rows(1, worksheet.num_rows)
    CSV.parse(csv).each.with_index do |row, index|
      j = 1
      for j in 1..row.count do
        worksheet[index + 1, j] = row[j - 1]
      end
    end
    puts "success! @#{worksheet_name}" if worksheet.save
  end

  private

  def start_session_with_auth
    credentials = Google::Auth::UserRefreshCredentials.new(
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      scope: [
        'https://www.googleapis.com/auth/drive',
        'https://spreadsheets.google.com/feeds/'
      ],
      refresh_token: ENV['GOOGLE_REFRESH_TOKEN']
    )
    @session = GoogleDrive::Session.from_credentials(credentials)
  end

  def worksheet(name)
    spreadsheet = @session.spreadsheet_by_url(@url)
    spreadsheet.worksheet_by_title(name)
  end
end
