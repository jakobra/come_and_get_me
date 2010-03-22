class ChangeNameToTitleOnTrack < ActiveRecord::Migration
  def self.up
    rename_column :tracks, :name, :title
  end

  def self.down
    rename_column :tracks, :title, :name
  end
end
