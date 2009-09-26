class CreateBrowseArtifactsTemplates < ActiveRecord::Migration
  def self.up
    create_table :browse_artifacts_templates do |t|
      t.integer :sp_template_id
      t.text :template
      t.text :css

      t.timestamps
    end
  end

  def self.down
    drop_table :browse_artifacts_templates
  end
end
