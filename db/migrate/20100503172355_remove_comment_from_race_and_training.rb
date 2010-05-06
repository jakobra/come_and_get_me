class RemoveCommentFromRaceAndTraining < ActiveRecord::Migration
  def self.up
    remove_column :trainings, :comment
    remove_column :races, :comment
  end

  def self.down
    add_column :trainings, :comment, :text
    add_column :races, :comment, :text
  end
end
