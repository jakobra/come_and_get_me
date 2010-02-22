class ChangeRacesPulseColumns < ActiveRecord::Migration
  def self.up
    rename_column :races, :max_pulse, :hr_max
    rename_column :races, :avg_pulse, :hr_avg
  end

  def self.down
    rename_column :races, :hr_max, :max_pulse
    rename_column :races, :hr_avg, :avg_pulse
  end
end
