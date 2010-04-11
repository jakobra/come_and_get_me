class AddStyleToSideModule < ActiveRecord::Migration
  def self.up
    add_column :side_modules, :style, :text
  end

  def self.down
    remove_column :side_modules, :style
  end
end
