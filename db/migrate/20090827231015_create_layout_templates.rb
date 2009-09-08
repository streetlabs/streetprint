class CreateLayoutTemplates < ActiveRecord::Migration
  def self.up
    create_table :layout_templates do |t|
      t.integer :sp_template_id
      t.text :template
      t.text :css

      t.timestamps
    end
  end

  def self.down
    drop_table :layout_templates
  end
end
