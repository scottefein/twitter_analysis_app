class AddInstagramUserIdToTrackPerson < ActiveRecord::Migration
  def change
    add_column :track_people, :instagram_user_id, :string
  end
end
