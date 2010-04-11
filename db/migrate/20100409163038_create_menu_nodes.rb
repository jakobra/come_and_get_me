class CreateMenuNodes < ActiveRecord::Migration
  def self.up
    create_table :menu_nodes do |t|
      t.string :title
      t.string :url
      t.integer :position
      t.integer :parent_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :menu_nodes
  end
end
