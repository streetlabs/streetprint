class AddSiteThemeIdToLayoutTemplates < ActiveRecord::Migration
  def self.up
    add_column :layout_templates, :site_theme_id, :integer
  end

  def self.down
    remove_column :layout_templates, :site_theme_id
  end
end
