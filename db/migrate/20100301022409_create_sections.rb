class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.integer :site_id
      t.integer :narrative_id
      t.integer :order_number
      t.text :content
      t.integer :media_id
      t.string :media_type
      t.integer :media_index

      t.timestamps
    end
  end

  def self.down
    drop_table :sections
  end
end
