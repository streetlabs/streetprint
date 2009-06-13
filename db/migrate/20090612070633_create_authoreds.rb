class CreateAuthoreds < ActiveRecord::Migration
  def self.up
    create_table :authoreds do |t|
      t.integer :author_id
      t.integer :item_id

      t.timestamps
    end
  end

  def self.down
    drop_table :authoreds
  end
end
