# frozen_string_literal: true

require 'mysql2'

class DatabaseClient
  @@client = Mysql2::Client.new(host: ENV['HOST'],
                                username: ENV['DB_USERNAME'],
                                password: ENV['DB_PASSWORD'],
                                database: ENV['DATABASE'])

  def self.all
    @@client.query('SELECT `twitter_accounts`.* FROM `twitter_accounts`')
  end

  def self.update(column, value, id)
    escaped_value = @@client.escape(value.to_s)
    begin
      @@client.query("UPDATE `twitter_accounts` SET #{column} = '#{escaped_value}' WHERE id = #{id}")
    rescue
      @@client = Mysql2::Client.new(host: ENV['HOST'],
                                    username: ENV['DB_USERNAME'],
                                    password: ENV['DB_PASSWORD'],
                                    database: ENV['DATABASE'])
      @@client.query("UPDATE `twitter_accounts` SET #{column} = '#{escaped_value}' WHERE id = #{id}")
    end
  end

  def self.add_account(name, password)
    @@client.query("INSERT INTO twitter_accounts (name, password, worksheet_name) VALUES ('#{name}', '#{password}', '#{name}')")
  end
end
