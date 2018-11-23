# This script is to setup DB in your local.
require 'mysql2'

client =Mysql2::Client.new(host: "localhost",
                           username: "root",
                           password: '')
client.query('CREATE DATABASE twitter_analytics_acquirer')
sql = <<SQL
create table twitter_analytics_acquirer10.twitter_accounts (
  id int not null auto_increment primary key,
  cookies text,
  name text not null,
  password text not null,
  worksheet_name text not null,
  created_at datetime  default current_timestamp,
  updated_at timestamp default current_timestamp on update current_timestamp
)
SQL
client.query(sql)
puts 'DB is successfully created!'
