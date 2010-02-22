class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :content
      t.integer :user_id
      t.integer :commentable_id
      t.string :commentable_type
      t.timestamps
    end
    
    add_column :users, :last_login_at, :datetime
    add_column :users, :last_login_ip, :string
    
    User.update_all(:last_login_ip => '127.0.0.1', :last_login_at => Time.now)
  end
  
  def self.down
    drop_table :comments
    remove_column :users, :last_login_at
    remove_column :users, :last_login_ip
  end
end
