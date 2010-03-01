class CreateNarratives < ActiveRecord::Migration
  def self.up
    create_table :narratives do |t|
	  t.integer :site_id
      t.string :title
      t.text :description
      t.boolean :markdown

      t.timestamps
    end
  end

  def self.down
    drop_table :narratives
  end
end
