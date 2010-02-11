class CreateStreetprintSettings < ActiveRecord::Migration
  def self.up
    create_table :streetprint_settings do |t|
      t.boolean :use_cloudfiles, :default => true
      t.string :cloudfiles_username
      t.string :cloudfiles_api_key
      t.string :cloudfiles_container
      
      t.timestamps
    end
  end

  def self.down
    drop_table :streetprint_settings
  end
end
