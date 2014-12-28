class CreateTrackPeople < ActiveRecord::Migration
  def change
    create_table :track_people do |t|
      t.string :name
      t.string :twitter_handle
      t.string :instagram_name
      t.string :foursquare_name

      t.timestamps
    end
  end
end
