Factory.define :user  do |f|
  f.sequence(:email) { |n| "user#{n}@example.com" }
  f.password "secret"
  f.password_confirmation { |u| u.password }
end

Factory.define :active_user, :class => User do |f|
  f.sequence(:email) { |n| "active_user#{n}@example.com" }
  f.password "secret"
  f.password_confirmation { |u| u.password }
  f.active true
end

Factory.define :item do |f|
  f.title "ItemTitle"
  f.published true
end

Factory.define :news_post do |f|
  f.title "NewsTitle"
  f.sequence(:content) { |n| "mock news post #{n}" }
end

Factory.define :site do |f|
  f.sequence(:name) { |n| "Mock Site #{n}" }
  f.sequence(:title) { |n| "mocksite.#{n}"}
  f.singular_item "Artifact"
  f.plural_item "Artifacts"
end

Factory.define :photo do |f|
  f.sequence(:photo_file_name) { |n| "mock_photo_#{n}" }
end

Factory.define :author do |f|
  f.sequence(:name) { |n| "author_#{n}" }
end

Factory.define :authored do |f|
end

Factory.define :categorization do |f|
end

Factory.define :category do |f|
  f.sequence(:name) { |n| "category_#{n}" }
end

Factory.define :document_type do |f|
  f.sequence(:name) { |n| "document_type_#{n}" }
end

Factory.define :membership do |f|
end

Factory.define :site_theme do |t|
  t.name 'Mock Theme'
  t.association :user, :factory => :user
end

[:show_site_template, :show_about_template, :show_news_posts_template, :show_artifact_template, 
  :browse_artifacts_template, :index_artifacts_template, :show_author_template, 
  :show_full_text_template, :show_google_location_template, :layout_template ].each do |page_template|
    Factory.define page_template do |p|
      p.association :site_theme, :factory => :site_theme
    end
  end
