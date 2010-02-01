class CreateTracksegments < ActiveRecord::Migration
  def self.up
    create_table :tracksegments do |t|
      t.references :track

      t.timestamps
    end
  end

  def self.down
    drop_table :tracksegments
  end
end
