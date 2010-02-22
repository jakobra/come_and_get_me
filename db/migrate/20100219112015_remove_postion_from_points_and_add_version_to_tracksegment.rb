class RemovePostionFromPointsAndAddVersionToTracksegment < ActiveRecord::Migration
  def self.up
    remove_column :points, :position
    add_column :tracksegments, :track_version, :integer
    Tracksegment.update_all(:track_version => 1)
  end

  def self.down
    add_column :points, :position, :integer
    remove_column :tracksegments, :track_version
  end
end
