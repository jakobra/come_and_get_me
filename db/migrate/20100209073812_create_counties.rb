class CreateCounties < ActiveRecord::Migration
  def self.up
    create_table :counties do |t|
      t.string :name
      t.string :code
      t.integer :numeric_code
      t.timestamps
    end
  end
  
  def self.down
    drop_table :counties
  end
end
