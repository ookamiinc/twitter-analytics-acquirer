# frozen_string_literal: true

require 'csv'
require 'googleauth'
require 'google_drive'

class GoogleSheetClient
  def initialize(url)
    @url = url
    start_session_with_auth
  end

  def write_in_spreadsheet(csv, worksheet_name, stored_csv_length)
    stored_csv_length = 0 unless stored_csv_length
    worksheet = worksheet(worksheet_name)
    worksheet.delete_rows(stored_csv_length + 1, worksheet.num_rows)
    CSV.parse(csv).each.with_index do |row, index|
      j = 1
      for j in 1..row.count do
        worksheet[index + stored_csv_length + 1, j] = row[j - 1]
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
