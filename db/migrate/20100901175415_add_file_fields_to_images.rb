class AddFileFieldsToImages < ActiveRecord::Migration
  def self.up
    change_table :images do |t|
      t.string :file_name
      t.integer :file_size
      t.string :file_type
      t.integer :height
      t.integer :width
    end
  end

  def self.down
    change_table :images do |t|
      t.remove :file_name
      t.remove :file_size
      t.remove :file_type
      t.remove :height
      t.remove :width
    end
  end
end
