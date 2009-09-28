class CreateCustomDataTypes < ActiveRecord::Migration
  def self.up
    create_table :custom_data_types do |t|
      t.string :name, :null => false
      t.text :description
      t.integer :site_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :custom_data_types
  end
end
