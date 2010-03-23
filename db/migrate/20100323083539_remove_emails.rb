class RemoveEmails < ActiveRecord::Migration
  def self.up
    drop_table :emails
  end
  
  def self.down
    create_table :emails do |t|
      t.string :from
      t.string :to
      t.string :subject
      t.text :body
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size

      t.timestamps
    end
  end
  
end
