require 'active_record'
require 'mysql2'

ActiveRecord::Base.establish_connection(
    "adapter" =>"mysql2",
    "database" => "twitter_analytics_acquirer"
)

class TwitterAccount < ActiveRecord::Base
end
