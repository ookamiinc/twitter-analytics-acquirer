require 'mysql2'

class TwitterAccount
  @client = Mysql2::Client.new(host: "localhost", username: "root", password: '', database: 'twitter_analytics_acquirer')

  def self.all
    @client.query("SELECT `twitter_accounts`.* FROM `twitter_accounts`").each
  end

  def self.update(column, value, id)
    escaped_value =  @client.escape(("#{value}"))
    @client.query("UPDATE `twitter_accounts` SET #{column} = '#{escaped_value}' WHERE  id = #{id}")
  end
end
