class AddBeforeAfterToMenuNodeSideModules < ActiveRecord::Migration
  def self.up
    add_column :menu_node_side_modules, :position_y, :boolean
  end

  def self.down
    remove_column :menu_node_side_modules, :position_y
  end
end
