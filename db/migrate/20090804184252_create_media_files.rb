class CreateMediaFiles < ActiveRecord::Migration
  def self.up
    create_table :media_files do |t|
      t.references :item
      t.timestamps
    end
    add_index :media_files, :item_id
  end

  def self.down
    drop_table :media_files
  end
end
