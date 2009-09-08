class CreateShowArtifactTemplates < ActiveRecord::Migration
  def self.up
    create_table :show_artifact_templates do |t|
      t.integer :sp_template_id
      t.text :template
      t.text :css

      t.timestamps
    end
  end

  def self.down
    drop_table :show_artifact_templates
  end
end
