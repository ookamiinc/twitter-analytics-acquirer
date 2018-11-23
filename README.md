twitter-analytics-acquirer
Post twitter analytics data to google spreadsheets

# [Required]

You need to specify the ENV values and setup DB.

# ENV

## Google Auth
GOOGLE_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID
GOOGLE_CLIENT_SECRET=YOUR_GOOGLE_CLIENT_SECRET
GOOGLE_REFRESH_TOKEN=YOUR_GOOGLE_REFRESH_TOKEN

## Google Spreadsheet
SPREADSHEET_URL=YOUR_SPREADSHEET_URL

You also need to create DB to store twitter_account's info.

# DB

## Create DB in development

run `bundle exec ruby scripts/setup.rb` and you can create DB in your local.
You can see the message below if you successfully created DB.
`DB is successfully created!`


## Add Twitter Account

run `bundle exec ruby scripts/add_account.rb #{name} #{password}`
and you can add team to DB.

ex) ``bundle exec ruby scripts/add_account.rb account1 password1`
Then you can add twitter_account which name is `account1` and password is `password1`.

You can see the message below if you successfully add account.
`Account is successfully created! Name:account1, Password:password1"`
