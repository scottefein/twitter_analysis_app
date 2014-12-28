CALLBACK_URL = ENV["CALLBACK_URL_FOR_INSTAGRAM"]

Instagram.configure do |config|
  config.client_id = ENV['INSTAGRAM_CLIENT_ID']
  config.client_secret = ENV['INSTAGRAM_CLIENT_SECRET']
end

TWITTER_CLIENT = Twitter::REST::Client.new do |config|
  config.consumer_key    = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
end

AlchemyAPI.configure do |config|
  config.apikey = ENV['ALCHEMY_API_KEY']
  config.output_mode = :json 
end
