class ChangeTaggings < ActiveRecord::Migration
  def self.up
    rename_column :taggings, :race_id, :track_id
  end

  def self.down
    rename_column :taggings, :track_id, :race_id
  end
end
