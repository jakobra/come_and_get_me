class ChangesToTracksAndPoints < ActiveRecord::Migration
  def self.up
    change_table :points do |t|
      t.remove :point_created_at
      t.remove :name
      t.remove :description
    end
    
    change_table :tracks do |t|
      t.date :date
      t.text :description
    end
    
    change_table :tracksegments do |t|
      t.remove :start_time
      t.remove :end_time
    end
    
    
  end

  def self.down
    change_table :points do |t|
      t.datetime :point_created_at
      t.string :name
      t.string :description
    end
    
    change_table :tracks do |t|
      t.remove :date
      t.remove :description
    end
    
    change_table :tracksegments do |t|
      t.datetime :start_time
      t.datetime :end_time
    end
  end
end
