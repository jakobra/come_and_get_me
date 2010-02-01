class AddPositionColumnToPoints < ActiveRecord::Migration
  def self.up
    add_column :points, :position, :integer
  end

  def self.down
    remove_column :points, :position
  end
end
