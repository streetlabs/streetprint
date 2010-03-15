class CreateShowNarrativeTemplates < ActiveRecord::Migration
  def self.up
    create_table :show_narrative_templates do |t|
      t.integer :site_theme_id
      t.text :template
      t.text :css

      t.timestamps
    end
  end

  def self.down
    drop_table :show_narrative_templates
  end
end
