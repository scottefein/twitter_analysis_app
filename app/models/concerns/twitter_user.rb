require "twitter_user/twitter_a_p_i.rb"
require "alchemy_wrapper.rb"

module TwitterUser
  extend ActiveSupport::Concern

  def friends
    TwitterAPI.get_friends_of(self.twitter_handle)
  end

  def friends_tweets
    friends_tweets = {}
    self.friends.each do |friend|
      friends_tweets[friend] = TwitterAPI.get_tweets_of(friend)
    end
    friends_tweets
  end

  def all_tweets(handle)
    Rails.cache.fetch("twitter/user/all_tweets/#{handle}", :expires_in => 6.hours) do
      get_all_tweets(handle)
    end
  end

  def tweets_sentiment_average
    AlchemyWrapper.sentiment_in_words(self.twitter_handle)
  end

  def tweeted_concepts
    AlchemyWrapper.grab_common_concepts(self.twitter_handle)
  end

  def tweeted_entities
    AlchemyWrapper.grab_entities_from_tweets(self.twitter_handle)
  end

  def taxonomy_of_tweets
    AlchemyWrapper.grab_taxonomy_of_tweets(self.twitter_handle)
  end

  def tweet_keywords
    AlchemyWrapper.grab_keywords_of_tweets(self.twitter_handle)
  end

  def tweet_category
    AlchemyWrapper.grab_tweet_categories(self.twitter_handle)
  end

  def friends_sentiments
    friends_sentiments = []
    friends.each do |handle|
      friends_sentiments << { :name => handle, :score => AlchemyWrapper.sentiment_of_one_person(handle)}
    end
    friends_sentiments.sort_by{|sentiment| sentiment["score"]}
  end

  def collect_with_max_id(collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response
    response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
  end

  def get_all_tweets(user)
    collect_with_max_id do |max_id|
      options = {count: 200, include_rts: false}
      options[:max_id] = max_id unless max_id.nil?
      TWITTER_CLIENT.user_timeline(user, options)
    end
  end

  def my_recent_tweets
    TwitterAPI.recent_tweets(self.twitter_handle)
  end
end