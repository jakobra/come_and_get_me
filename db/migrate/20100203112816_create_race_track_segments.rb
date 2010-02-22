class CreateRaceTrackSegments < ActiveRecord::Migration
  def self.up
    create_table :race_track_segments do |t|
      t.references :track
      t.references :race_track
      t.integer :quantity

      t.timestamps
    end
  end

  def self.down
    drop_table :race_track_segments
  end
end
