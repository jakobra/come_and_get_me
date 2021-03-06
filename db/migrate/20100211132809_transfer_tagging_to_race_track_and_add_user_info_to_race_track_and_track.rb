class TransferTaggingToRaceTrackAndAddUserInfoToRaceTrackAndTrack < ActiveRecord::Migration
  def self.up
    rename_column :taggings, :track_id, :race_track_id
    #Tagging.delete_all
    
    add_column :race_tracks, :created_by_user_id, :integer
    add_column :race_tracks, :last_updated_by_user_id, :integer
    
    add_column :tracks, :created_by_user_id, :integer
    add_column :tracks, :last_updated_by_user_id, :integer
  end

  def self.down
    rename_column :taggings, :race_track_id, :track_id
    #Tagging.delete_all
    remove_column :race_tracks, :created_by_user_id
    remove_column :race_tracks, :last_updated_by_user_id
    remove_column :tracks, :created_by_user_id
    remove_column :tracks, :last_updated_by_user_id
  end
end
