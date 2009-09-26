class DropSpTemplates < ActiveRecord::Migration
  def self.up
    drop_table :sp_templates
  end

  def self.down
    create_table :sp_templates do |t|
      t.string :name
      t.integer :user_id
      
      #paperclip fields
      t.string   :icon_file_name
      t.string   :icon_content_type
      t.integer  :icon_file_size
      t.datetime :icon_updated_at

      t.timestamps
    end
  end
end
