class ChangeSiteSpTemplateToSiteTheme < ActiveRecord::Migration
  def self.up
    rename_column(:sites, :sp_template_id, :site_theme_id)
  end

  def self.down
    rename_column(:sites, :site_theme_id, :sp_template_id)
  end
end
