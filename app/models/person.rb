class Person < ActiveRecord::Base
	include InstagramUser
	include TwitterUser


	def most_common_photo_tags
		tags = Hash.new 0
		all_photo_tags.each do |tag|
			tags[tag["text"]] += 1
		end
		tags.sort_by{|a,b| b}.reverse
	end

	def all_photo_tags
		tags = []
		recent_photos_with_tags.each do |photo|
			tags += photo.image_tags
		end
		tags
	end

	def recent_photos
		photos = []
		enabled_photo_networks.each do |network|
			photos += self.send("#{network.downcase}_photos")
		end
		photos
	end

	def recent_photos_with_tags
		photos_with_tags = []
		recent_photos.each do |photo|
			if photo.image_tags && photo.image_tags.count > 0
				photos_with_tags << photo
			end
		end
		photos_with_tags
	end

	def enabled_networks
		["TWITTER", "INSTAGRAM"]
	end

	def enabled_photo_networks
		["INSTAGRAM"]
	end
end
