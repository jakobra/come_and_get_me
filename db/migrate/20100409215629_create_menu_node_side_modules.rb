class CreateMenuNodeSideModules < ActiveRecord::Migration
  def self.up
    create_table :menu_node_side_modules do |t|
      t.integer :menu_node_id
      t.integer :side_module_id
      t.boolean :position

      t.timestamps
    end
  end

  def self.down
    drop_table :menu_node_side_modules
  end
end
