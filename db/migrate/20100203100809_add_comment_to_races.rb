class AddCommentToRaces < ActiveRecord::Migration
  def self.up
    add_column :races, :comment, :text
  end

  def self.down
    remove_column :races, :comment
  end
end
