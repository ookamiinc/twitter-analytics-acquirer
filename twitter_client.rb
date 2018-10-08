require 'twitter'

# Simple Wrapper for Twitter::REST::Client instance
module Twitter
  class << self
    attr_writer :client

    def client
      #
      # See more about twitter gem
      # https://github.com/sferik/twitter
      #
      @client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
      end
      @client
    end
  end
end
