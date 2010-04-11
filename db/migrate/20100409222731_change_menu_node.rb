class ChangeMenuNode < ActiveRecord::Migration
  def self.up
    add_column :menu_nodes, :viewable, :boolean
  end

  def self.down
    remove_column :menu_nodes, :viewable
  end
end
