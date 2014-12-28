class PeopleController < ApplicationController
	def show
		person = params[:user_id] ? Person.find(params[:user_id]) : Person.first
		session[:user_id] = person.id
		@name = person.name
		@recent_photos = person.recent_photos_with_tags
		@photo_tags = person.most_common_photo_tags
		@concepts = person.tweeted_concepts
		@sentiment_of_tweets = person.tweets_sentiment_average
		if person.instagram_access_token
			@instagram_enabled = true
		end
		render :show
	end

	def create
		@person = Person.create(people_params)
		if @person.save
			redirect_to @person
		else
			render :new
		end
	end

	def new
		@person = Person.new
	end

	def people_params
    params.require(:person).permit(:name, :twitter_handle, :instagram_name)
  end
end