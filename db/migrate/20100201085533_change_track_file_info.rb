class ChangeTrackFileInfo < ActiveRecord::Migration
  def self.up
    change_table :tracks do |t|
      t.rename :gpx_file_name, :track_file_name
      t.rename :gpx_content_type, :track_content_type
      t.rename :gpx_file_size, :track_file_size
    end
  end

  def self.down
    change_table :tracks do |t|
      t.rename :track_file_name, :gpx_file_name
      t.rename :track_content_type, :gpx_content_type
      t.rename :track_file_size, :gpx_file_size 
    end
  end
end
