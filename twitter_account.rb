# frozen_string_literal: true

require 'mysql2'

class TwitterAccount
  host = ENV['HOST']
  username = ENV['USERNAME']
  password = ENV['PASSWORD']
  database = ENV['DATABASE']
  @client = Mysql2::Client.new(host: host, username: username, password: password, database: database)

  def self.all
    @client.query('SELECT `twitter_accounts`.* FROM `twitter_accounts`').each
  end

  def self.update(column, value, id)
    escaped_value = @client.escape(value.to_s)
    @client.query("UPDATE `twitter_accounts` SET #{column} = '#{escaped_value}' WHERE id = #{id}")
  end
end
