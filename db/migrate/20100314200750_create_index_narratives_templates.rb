class CreateIndexNarrativesTemplates < ActiveRecord::Migration
  def self.up
    create_table :index_narratives_templates do |t|
      t.integer :site_theme_id
      t.text :template
      t.text :css

      t.timestamps
    end
  end

  def self.down
    drop_table :index_narratives_templates
  end
end
