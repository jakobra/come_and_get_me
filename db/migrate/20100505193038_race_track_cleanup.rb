class RaceTrackCleanup < ActiveRecord::Migration
  def self.up
    drop_table :race_tracks
    drop_table :race_track_segments
    rename_column :races, :race_track_id, :track_id
    rename_column :taggings, :race_track_id, :track_id
  end

  def self.down
    create_table :race_tracks do |t|
      t.string :title
      t.text :description
      t.integer :municipality_id
      t.integer :created_by_user_id
      t.integer :last_updated_by_user_id

      t.timestamps
    end
    
    create_table :race_track_segments do |t|
      t.integer :race_track_id
      t.integer :track_id
      t.integer :quantity

      t.timestamps
    end
    
    rename_column :races, :track_id, :race_track_id
    rename_column :taggings, :track_id, :race_track_id
  end
end
