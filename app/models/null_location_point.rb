class NullLocationPoint
	def initialize
		@latitude = "0.0"
		@longitude = "0.0"
	  @datetime = Time.at(0).to_datetime
	  @name = "Unknown Location"
	end

	attr_reader :latitude, :longitude, :datetime, :name
end