class AddFileToTracks < ActiveRecord::Migration
  def self.up
    change_table :tracks do |t|
      t.string :file_name
      t.integer :file_size
      t.string :file_type
      t.binary :file_content, :limit => 3.megabyte
      t.remove :track_file_name
      t.remove :track_file_size
      t.remove :track_content_type
    end
    change_table :images do |t|
      t.remove :image_file_name
      t.remove :image_content_type
      t.remove :image_file_size
      t.remove :image_updated_at
    end
  end

  def self.down
    change_table :tracks do |t|
      t.remove :file_name
      t.remove :file_size
      t.remove :file_type
      t.remove :file_content
      t.string :track_file_name
      t.integer :track_file_size
      t.string :track_content_type
    end
    
    change_table :images do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
    end
  end
end
