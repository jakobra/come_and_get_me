class AddTitleToSideModule < ActiveRecord::Migration
  def self.up
    add_column :side_modules, :title, :string
  end

  def self.down
    remove_column :side_modules, :title
  end
end
