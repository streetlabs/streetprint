class CreateCustomDatas < ActiveRecord::Migration
  def self.up
    create_table :custom_datas do |t|
      t.text :data
      t.integer :site_id
      t.integer :custom_data_type_id
      t.integer :data_targetable_id
      t.string  :data_targetable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :custom_datas
  end
end
