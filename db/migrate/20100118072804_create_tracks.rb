class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string :name
      t.string :gpx_file_name
      t.string :gpx_content_type
      t.integer :gpx_file_size

      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
