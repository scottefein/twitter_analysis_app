class Photo
	def initialize(url, caption, latitude, longitude, created_at)
		@caption = caption ? caption : "No Caption"
		@url = url
		if latitude != nil && longitude != nil
	 		@location = LocationPoint.new([latitude, longitude], created_at)
	 	else
	 		@location = NullLocationPoint.new
	 	end
	end

	def display_text
		caption + " -- #{location.name}"
	end

	def datetime
		location.datetime
	end

	def image_tags
		Rails.cache.fetch("/image_tags_for_url/#{url}") do
			::AlchemyAPI::ImageTagging.new.search(:url => url)
		end
	end

	attr_reader :location, :caption, :url
end