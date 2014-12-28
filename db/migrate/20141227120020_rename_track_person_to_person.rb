class RenameTrackPersonToPerson< ActiveRecord::Migration
  def change
    rename_table :track_people, :people
  end 
end