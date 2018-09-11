twitter-analytics-acquirer
Post twitter analytics data to google spreadsheets

ENV
You need to specify the ENV values below.

# [ Set Required at each accounts]
Below is some examples.You should change natural number if you add more accounts.

# Twitter Auth
TWITTER_ID1=YOUR_FIRST_TWITTER_ID
TWITTER_PASS1=YOUR_FIRST_TWITTER_PASSWORD
# Google Spreadsheet
WORKSHEET_NAME1=YOUR_FIRST_WORKSHEET_NAME

# Twitter Auth
TWITTER_ID2=YOUR_SECOND_TWITTER_ID
TWITTER_PASS2=YOUR_SECOND_TWITTER_PASSWORD
# Google Spreadsheet
WORKSHEET_NAME2=YOUR_SECOND_WORKSHEET_NAME

# [Required]

# Google Auth
GOOGLE_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID
GOOGLE_CLIENT_SECRET=YOUR_GOOGLE_CLIENT_SECRET
GOOGLE_REFRESH_TOKEN=YOUR_GOOGLE_REFRESH_TOKEN

### Notice
We can't define GOOGLE_REFRESH_TOKEN by .env file.

# Google Spreadsheet
SPREADSHEET_URL=YOUR_SPREADSHEET_URL
