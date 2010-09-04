class AddFileContentToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :file_content, :binary, :limit => 3.megabyte
  end

  def self.down
    remove_column :images, :file_content
  end
end
