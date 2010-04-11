class CreateSideModules < ActiveRecord::Migration
  def self.up
    create_table :side_modules do |t|
      t.text :content
      t.timestamps
    end
  end
  
  def self.down
    drop_table :side_modules
  end
end
