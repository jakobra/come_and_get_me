class AddSideModuleMatchToMenuNodes < ActiveRecord::Migration
  def self.up
    add_column :menu_nodes, :side_module_regex, :string
  end

  def self.down
    remove_column :menu_nodes, :side_module_regex
  end
end
