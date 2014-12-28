module InstagramUser
  extend ActiveSupport::Concern

  #private

  def instagram_photos
    Rails.cache.fetch("instagram/user/#{self.id}", :expires_in => 5.minutes) do
      get_instagram_posts
    end
  end

  included do
    before_create :set_instagram_user_id
  end

  def get_instagram_posts(photos=[])
    max_id = ""
    begin
      instagram_data = Instagram.user_recent_media(instagram_user_id, :max_id => max_id)
      process_instagram_photos(photos, instagram_data)
      max_id = instagram_data.pagination.next_max_id
    end while max_id
    photos
  end

  def process_instagram_photos(photos=[], instagram_data)
    instagram_data.each do |photo|
      photos << Photo.new(photo.images.low_resolution.url, photo.caption.try(:text), photo.location.try(:latitude), photo.location.try(:longitude), photo.created_time)
    end
    photos
  end

  def set_instagram_user_id
    self.instagram_user_id = Instagram.user_search(instagram_name)[0][:id]
  end
end