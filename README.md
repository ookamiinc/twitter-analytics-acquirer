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
