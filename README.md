twitter-analytics-acquirer
Post twitter analytics data to google spreadsheets

ENV
You need to specify the ENV values below.

# [Required]

# Google Auth
GOOGLE_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID
GOOGLE_CLIENT_SECRET=YOUR_GOOGLE_CLIENT_SECRET
GOOGLE_REFRESH_TOKEN=YOUR_GOOGLE_REFRESH_TOKEN

### Notice
We can't define GOOGLE_REFRESH_TOKEN by .env file.

# Google Spreadsheet
SPREADSHEET_URL=YOUR_SPREADSHEET_URL

DB
You need to create TwitterAccount object before run the script.

# [Required]
TwitterAccount.create
  (name: YOUR_TWITTER_ID,
   password: YOUR_TWITTER_PASSWORD,
   worksheet_name: YOUR_WORKSHEET_NAME)
