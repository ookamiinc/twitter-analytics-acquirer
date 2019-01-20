# TwitterAnalyticsAcquirer

## About
TwitterAnalyticsAcquirer is a tool which gets Twitter analytics data and write them to GoogleSpreadsheet.

## Setting
You need to set up
  - ENV values
   - DB

### ENV values

#### Google Auth
`GOOGLE_CLIENT_ID` = YOUR_GOOGLE_CLIENT_ID

`GOOGLE_CLIENT_SECRET` = YOUR_GOOGLE_CLIENT_SECRET

`GOOGLE_REFRESH_TOKEN` = YOUR_GOOGLE_REFRESH_TOKEN

#### Google Spreadsheet
`SPREADSHEET_URL` = YOUR_SPREADSHEET_URL

### DB

Run

```
ruby scripts/setup.rb
```
 and you can create DB in your development environment.

You can see the message below if you successfully created DB.

```
DB is successfully created!
```

## Add Twitter Account

Run

```
 ruby scripts/add_account.rb #{name} #{password}
```
and you can add team to DB.

### Example
When you run

```
ruby scripts/add_account.rb account1 password1
```
Then you can add twitter_account which name = `account1` , password = `password1`.

You can see the message below if you successfully add account.

```
Account is successfully created! Name:account1, Password:password1"
```

## Remove Twitter Account

There are two ways.

1. Remove twitter account from DB
2. Add the twitter account to `SKIPPED_ACCOUNT_NAMES`


### 1. Remove the twitter account from DB

When you plan never to get the twitter account's data, I recommend this way.

### 2. Add the twitter account to `SKIPPED_ACCOUNT_NAMES`

You can avoid getting the twitter account's data by adding it to `SKIPPED_ACCOUNT_NAMES`.

`SKIPPED_ACCOUNT_NAMES` is ENV value and should be array.

### Example

`SKIPPED_ACCOUNT_NAMES` = ['skipped_twitter_account', 'skipped_twitter_account2']

Then you can avoid getting data of `skipped_twitter_account` and `skipped_twitter_account2` with not removing them from DB.
