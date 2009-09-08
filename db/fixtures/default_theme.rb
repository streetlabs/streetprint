themes = [
  ['Default', 1],
  ['Default Hex', 2],
  ['Parchment', 3]
  ]

themes.each do |dir, i|
  SiteTheme.seed(:user_id, :name) do |t|
    t.id = i
    t.name = dir
    t.user_id = nil
    t.icon = File.new(File.join(RAILS_ROOT, 'config', 'themes', dir, 'icon.jpg'))
  end
  
  Dir[File.join(RAILS_ROOT, 'config', 'themes', dir, 'images', '*')].each do |file|
    ThemeImage.seed(:site_theme_id, :image_file_name) do |t|
      t.site_theme_id = i
      t.image_file_name = File.basename(file)
      t.image = File.new(file)
    end
  end

  LayoutTemplate.seed(:site_theme_id) do |t|
    t.site_theme_id = i
    t.template = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'layout', 'template.liquid'))
    t.css = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'layout', 'css.css'))
  end
  ShowSiteTemplate.seed(:site_theme_id) do |t|
    t.site_theme_id = i
    t.template = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'show_site', 'template.liquid'))
    t.css = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'show_site', 'css.css'))
  end
  ShowAboutTemplate.seed(:site_theme_id) do |t|
    t.site_theme_id = i
    t.template = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'show_about', 'template.liquid'))
    t.css = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'show_about', 'css.css'))
  end
  ShowNewsPostsTemplate.seed(:site_theme_id) do |t|
    t.site_theme_id = i
    t.template = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'show_news_posts', 'template.liquid'))
    t.css = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'show_news_posts', 'css.css'))
  end
  ShowArtifactTemplate.seed(:site_theme_id) do |t|
    t.site_theme_id = i
    t.template = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'show_artifact', 'template.liquid'))
    t.css = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'show_artifact', 'css.css'))
  end
  BrowseArtifactsTemplate.seed(:site_theme_id) do |t|
    t.site_theme_id = i
    t.template = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'browse_artifacts', 'template.liquid'))
    t.css = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'browse_artifacts', 'css.css'))
  end
  IndexArtifactsTemplate.seed(:site_theme_id) do |t|
    t.site_theme_id = i
    t.template = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'index_artifacts', 'template.liquid'))
    t.css = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'index_artifacts', 'css.css'))
  end
  ShowAuthorTemplate.seed(:site_theme_id) do |t|
    t.site_theme_id = i
    t.template = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'show_author', 'template.liquid'))
    t.css = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'show_author', 'css.css'))
  end
  ShowFullTextTemplate.seed(:site_theme_id) do |t|
    t.site_theme_id = i
    t.template = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'show_full_text', 'template.liquid'))
    t.css = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'show_full_text', 'css.css'))
  end
  ShowGoogleLocationTemplate.seed(:site_theme_id) do |t|
    t.site_theme_id = i
    t.template = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'show_google_location', 'template.liquid'))
    t.css = File.read(File.join(RAILS_ROOT, 'config', 'themes', dir, 'show_google_location', 'css.css'))
  end
  
end