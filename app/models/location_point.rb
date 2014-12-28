class LocationPoint
	include Comparable

	def <=>(anOther)
    datetime <=> anOther.datetime
  end

	def initialize(points, timestamp)
		@latitude = points[0]
		@longitude = points[1]
	  @datetime = Time.at(timestamp.to_i).to_datetime
	  @name = formatted_name
	end

	def lat_long
		[latitude,longitude]
	end

	def formatted_name
		if !place.blank?
			(place.city ? place.city + ", " : "") + (place.state ? place.state + ", " : "") + (place.country)
		else
			"Unknown Location"
		end
	end

	def place
		Geocoder.search(lat_long).first
	end

	attr_reader :latitude, :longitude, :datetime, :name
end