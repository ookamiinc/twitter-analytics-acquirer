class GoogleDataSender
  def session_to_google_auth
    credentials = Google::Auth::UserRefreshCredentials.new(
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      scope: [
        "https://www.googleapis.com/auth/drive",
        "https://spreadsheets.google.com/feeds/",
      ],
      refresh_token: ENV['GOOGLE_REFRESH_TOKEN'])
    session = GoogleDrive::Session.from_credentials(credentials)
    session
  end

  def find_work_sheet(session, sp_url)
    sp = session.spreadsheet_by_url(sp_url)
    ws = sp.worksheet_by_title("test_volley")
    ws
  end

  def send_data_to_spreadsheet(analytics_file, ws)
    i = 1
    CSV.parse(analytics_file).each do |csv|
      a = 1
      for a in 1..40 do
        ws[i,a] =csv[a-1]
      end
      i += 1
    end
    puts 'success' if ws.save
  end
end
