class CreateRaces < ActiveRecord::Migration
  def self.up
    create_table :races do |t|
      t.references :event
      t.float :distance
      t.time :time
      t.integer :max_pulse
      t.integer :avg_pulse

      t.timestamps
    end
  end

  def self.down
    drop_table :races
  end
end
