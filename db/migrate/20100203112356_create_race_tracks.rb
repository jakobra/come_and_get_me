class CreateRaceTracks < ActiveRecord::Migration
  def self.up
    create_table :race_tracks do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
    rename_column :races, :track_id, :race_track_id
  end

  def self.down
    drop_table :race_tracks
    rename_column :races, :race_track_id, :track_id
  end
end
