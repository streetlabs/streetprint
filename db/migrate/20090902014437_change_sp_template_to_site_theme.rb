class ChangeSpTemplateToSiteTheme < ActiveRecord::Migration
  def self.up
    [
      :show_site_templates,
      :show_about_templates,
      :show_news_posts_templates,
      :show_artifact_templates,
      :browse_artifacts_templates,
      :index_artifacts_templates,
      :show_author_templates,
      :show_full_text_templates,
      :show_google_location_templates
    ].each do |table|
      rename_column(table, :sp_template_id, :site_theme_id)
    end
  end

  def self.down
    [
      :show_site_templates,
      :show_about_templates,
      :show_news_posts_templates,
      :show_artifact_templates,
      :browse_artifacts_templates,
      :index_artifacts_templates,
      :show_author_templates,
      :show_full_text_templates,
      :show_google_location_templates
    ].each do |table|
      rename_column(table, :site_theme_id, :sp_template_id)
    end
  end
end
