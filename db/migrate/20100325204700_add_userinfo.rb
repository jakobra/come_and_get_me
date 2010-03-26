class AddUserinfo < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.integer :municipality_id
      t.boolean :gender
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :municipality_id
      t.remove :gender
    end
  end
end
