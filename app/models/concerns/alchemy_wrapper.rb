module AlchemyWrapper
	class << self
		def sentiment_of_one_person(handle)
	    total_sentiment,sentiments_used = 0,0 
	    tweet_sentiments(handle).each do |sentiment|
	      if sentiment && sentiment["score"] != 0
	        total_sentiment += sentiment["score"].to_f
	        sentiments_used += 1
	      end
	    end
	    unless sentiments_used == 0 then total_sentiment/sentiments_used else return 0 end
	  end

	  def tweet_sentiments(handle)
	    sentiments = []
	    TwitterAPI.get_tweets_of(handle).each do |tweet|
	      sentiments << Rails.cache.fetch("sentiment/for/tweet/#{tweet.id}") do
	        AlchemyAPI.search(:sentiment_analysis, text: '#{tweet.text}')
	      end
	    end
	    sentiments
	  end

	  def sentiment_in_words(handle)
	    sentiment  = sentiment_of_one_person(handle)
	    if sentiment > 0
	      return "positive"
	    elsif sentiment < 0
	      return "negative"
	    else
	      return "neutral"
	    end
	  end

	  def grab_common_concepts(handle)
	    concept_array = []
	    concepts_response = AlchemyAPI::ConceptTagging.new.search(text: TwitterAPI.concatenated_tweets(handle))
	    concepts_response.each do |concept|
	      if concept["relevance"].to_f >= 0.60
	        concept_array << concept["text"]
	      end
	    end
	    concept_array.uniq
	  end

	  def grab_entities_from_tweets(handle)
	    entities = []
	    AlchemyAPI::EntityExtraction.new.search(text: TwitterAPI.concatenated_tweets(handle)).each do |entity|
	      if entity["disambiguated"]
	        entities << entity["disambiguated"]["name"]
	      else
	        entities << entity["text"]
	      end
	    end
	    entities.uniq
	  end

	  def grab_taxonomy_of_tweets(handle)
	    categories = []
	    AlchemyAPI::Taxonomy.new.search(text: TwitterAPI.concatenated_tweets(handle)).each do |category|
	      categories << category["label"]
	    end
	    categories
	  end

	  def grab_keywords_of_tweets(handle)
	    keywords = []
	    AlchemyAPI::KeywordExtraction.new.search(text: TwitterAPI.concatenated_tweets(handle)).each do |keyword|
	      keywords << keyword["text"] if keyword["relevance"].to_f > 0.6
	    end
	    keywords
	  end

	  def grab_tweet_categories(handle)
	    AlchemyAPI::TextCategorization.new.search(text: ::TwitterAPI.concatenated_tweets(handle))["category"]
	  end
	end
end