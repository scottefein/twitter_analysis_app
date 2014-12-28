class InstagramController < ApplicationController
	def instagram_connect
		redirect_to Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
	end

	def instagram_callback
		response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  	person = Person.find(session[:user_id])
  	person.instagram_access_token = response.access_token
  	person.save!
  	redirect_to '/'
	end
end