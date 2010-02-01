class AddStartAndStopTimeToTracksegment < ActiveRecord::Migration
  def self.up
    add_column :tracksegments, :start_time, :datetime
    add_column :tracksegments, :end_time, :datetime
  end

  def self.down
    remove_column :tracksegments, :start_time
    remove_column :tracksegments, :end_time
  end
end
