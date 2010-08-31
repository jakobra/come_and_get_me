class AddDistanceToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :distance, :decimal, :precision => 7, :scale => 3
  end

  def self.down
    remove_column :tracks, :distance
  end
end
