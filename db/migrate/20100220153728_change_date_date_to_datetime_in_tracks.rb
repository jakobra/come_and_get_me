class ChangeDateDateToDatetimeInTracks < ActiveRecord::Migration
  def self.up
    change_column :tracks, :date, :datetime
    remove_column :tracks, :last_updated_by_user_id
  end

  def self.down
    change_column :tracks, :datetime, :date
    add_column :tracks, :last_updated_by_user_id, :integer
  end
end
