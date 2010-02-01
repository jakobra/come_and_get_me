class CreatePoints < ActiveRecord::Migration
  def self.up
    create_table :points do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.float :elevation
      t.string :description
      t.datetime :point_created_at
      t.references :tracksegment

      t.timestamps
    end
  end

  def self.down
    drop_table :points
  end
end
