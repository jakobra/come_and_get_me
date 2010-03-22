class RemoveTitleFromTrainingAddAdminToUser < ActiveRecord::Migration
  def self.up
    remove_column :trainings, :title
    add_column :users, :admin, :boolean
    User.update_all( "admin = false" )
  end

  def self.down
    add_column :trainings, :title, :string
    remove_column :users, :admin
  end
end
