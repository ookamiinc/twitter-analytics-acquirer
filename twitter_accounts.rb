require 'active_record'
require 'mysql2'

ActiveRecord::Base.establish_connection(
    "adapter" =>"mysql2",
    "database" => "twitter_analytics_acquirer"
)

class TwitterAccounts < ActiveRecord::Base
  def self.create_or_update(params)
    twitter_account = TwitterAccounts.find_or_initialize_by(params)
    twitter_account.update_attributes(params)
  end
end
