class ChangeDateToDateForTrainingAndAddTrackIdToRace < ActiveRecord::Migration
  def self.up
    change_column :trainings, :date, :date
    add_column :races, :track_id, :integer
  end

  def self.down
    change_column :trainings, :date, :datetime
    remove_column :races, :track_id
  end
end
