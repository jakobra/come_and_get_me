class CreateMunicipalities < ActiveRecord::Migration
  def self.up
    create_table :municipalities do |t|
      t.string :name
      t.integer :code
      t.references :county
      t.timestamps
    end
    
    add_column :tracks, :municipality_id, :integer
    add_column :race_tracks, :municipality_id, :integer
  end
  
  def self.down
    drop_table :municipalities
    
    remove_column :tracks, :municipality_id
    remove_column :race_tracks, :municipality_id
  end
end
