class AddInstagramAccessTokenToTrackPerson < ActiveRecord::Migration
  def change
    add_column :track_people, :instagram_access_token, :string
  end
end
