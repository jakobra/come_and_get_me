class AddPublicToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :public, :boolean
  end

  def self.down
    remove_column :pages, :public
  end
end
