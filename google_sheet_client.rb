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
    stored_csv_length = 0
    worksheet = worksheet(worksheet_name)
    parsed_csv_without_header = CSV.parse(csv)[1..-1]
    return unless parsed_csv_without_header
    reversed_csv = parsed_csv_without_header.reverse
    reversed_csv.each.with_index do |row, index|
      for j in 1..row.count do
        worksheet[index + 2, j] = row[j - 1] #現在は２行目から書き込まれているようにしている
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
