class AddTrainingIdToEventAndMaxpulseToUser < ActiveRecord::Migration
  def self.up
    add_column :races, :training_id, :integer
    add_column :users, :birthday_year, :integer
  end

  def self.down
    remove_column :events, :training_id
    remove_column :users, :birthday_year
  end
end
