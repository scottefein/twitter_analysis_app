module TwitterAPI
  class << self

    def process_tweet(tweet)
      if tweet.try(:place).try(:bounding_box).try(:coordinates).is_a? Array
        center = tweet.place.bounding_box.coordinates[0].transpose.map{|c| c.inject{|a, b| a + b}.to_f / c.size}.reverse
        return !center.blank? ? LocationPoint.new(center, tweet.created_at) : NullLocationPoint.new
      end
    end

    def get_friends_of(handle)
      Rails.cache.fetch("twiter/user/all_friends/#{handle}", :expires_in => 6.hours) do
        all_friends = []
        TWITTER_CLIENT.friends(handle).each do |friend|
          all_friends << friend.screen_name
        end
        all_friends
      end
    end

    def recent_tweets(handle)
      Rails.cache.fetch("twitter/user/#{handle}/recent_tweets", :expires_in => 5.minutes) do
        ::TwitterAPI.get_tweets(20, "recent", handle)
      end
    end

    def get_tweets(number, result_type, handle)
      begin
          TWITTER_CLIENT.search("from:#{handle}", :result_type => "#{result_type}").take(number)
      rescue
        return []
      end
    end

    def get_tweets_of(handle)
      Rails.cache.fetch("twitter/user/#{handle}/friends/#{handle}/recent_tweets", :expires_in => 1.hours) do
        recent_tweets(handle)
      end
    end

    def concatenated_tweets(handle)
      all_text = ""
      get_tweets_of(handle).each do |text|
        all_text += "#{text.text} "
      end
      all_text
    end
  end
end