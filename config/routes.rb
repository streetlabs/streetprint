ActionController::Routing::Routes.draw do |map|
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.register '/register/:activation_code', :controller => 'visitor/activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'visitor/activations', :action => 'create'
  map.admin 'admin', :controller => 'user/my_sites', :action => 'show'
  
  map.www_root  '', :controller => 'visitor/visitors', :action => :index, :conditions => { :subdomain => /www/ }
  map.site_root '', :controller => 'visitor/sites', :action => "show", :conditions => { :subdomain => /.+/ }
  
  map.resources :users
  map.resources :password_resets, :controller => 'user/password_resets'
  map.resources :visitors, :controller => 'visitor/visitors'
  map.resources :pages
  
  map.resource :user_session
  map.resource :account, :controller => "users"
  map.resource :sites_administration, :controller => "sites_administration"
  
  ## require a site in subdomain
  map.resources :items, :controller => 'visitor/items', :only => [:index, :show] do |item|
    item.resource :google_location, :controller => 'visitor/google_locations',  :only => :show
    item.resource :full_text,       :controller => 'visitor/full_texts',        :only => :show
  end
  map.resources 'itemadmin', :controller => 'user/items' do |item|
    item.resource :google_location, :controller => 'user/google_locations'
    item.resource :full_text,       :controller => 'user/full_texts'
  end
  
  map.resources 'authoradmin',  :controller => 'user/authors'
  map.resources :authors,       :controller => 'visitor/authors', :only => :show
  
  map.resources 'newsadmin',     :controller => 'user/news_posts'
  map.resources :news_posts,      :controller => 'visitor/news_posts', :only => :index
  
  map.resources :categories,          :controller => 'user/categories'
  map.resources :document_types,      :controller => 'user/document_types'
  map.resources :custom_data_types,   :controller => 'user/custom_data_types'
  map.resources :memberships,         :controller => 'user/memberships'
  
  map.resources :custom_datas,  :controller => 'user/custom_datas'
  
  map.resource :browse,         :controller => 'visitor/browses'
  map.resource :about,          :controller => 'visitor/abouts'
  map.resource :sitestyle,      :controller => 'user/sitethemes'
  map.resource :featured_item,  :controller => 'user/featured_items'
  map.resource :publish_item,   :controller => 'user/publish_items'
  ## end require subdomain
  
  
  # user paths like /siteadmin/4/itemadmin/6/google_location/edit. urls like revrom.streetprint.org/itemadmin/6 are taken care of above
  map.resources 'siteadmin', :except => :show, :controller => 'user/sites' do |site|
    site.resources 'itemadmin', :controller => 'user/items' do |item|
      item.resource :google_location, :controller => 'user/google_locations'
      item.resource :custom_datas, :controller =>'user/custom_datas'
    end
    
    site.resources 'authoradmin',       :controller => 'user/authors'
    site.resources 'newsadmin',         :controller => 'user/news_posts'
    site.resources :categories,         :controller => 'user/categories'
    site.resources :document_types,     :controller => 'user/document_types'
    site.resources :custom_data_types,  :controller => 'user/custom_data_types'
    site.resources :memberships,        :controller => 'user/memberships'

    site.resource :sitestyle,  :controller => 'user/sitethemes'
    site.resource :featured_item,  :controller => 'user/featured_items'
    site.resource :publish_item,   :controller => 'user/publish_items'
  end
  # visitor paths like /sites/1/items/2/google_location. urls like revrom.streetprint.org/items/2/google_location handled above
  map.resources :sites, :controller => 'visitor/sites' do |site|
    site.resources :items, :controller => 'visitor/items', :only => [:index, :show] do |item|
      item.resource :google_location, :controller => 'visitor/google_locations',  :only => :show
      item.resource :custom_datas,    :controller =>'user/custom_datas',          :only => :show
      item.resource :full_text,       :controller => 'visitor/full_texts',        :only => :show
    end
    
    site.resources :authors,      :controller => 'visitor/authors', :only => :show

    site.resources :news_posts,   :controller => 'visitor/news_posts'

    site.resource :browse,         :controller => 'visitor/browses'
    site.resource :about,          :controller => 'visitor/abouts'
  end
  
  
  map.resources :site_themes, :controller => 'user/site_themes' do |theme|
    theme.resource :show_site_template,             :controller => 'user/show_site_template'
    theme.resource :show_about_template,            :controller => 'user/show_about_template'
    theme.resource :show_news_posts_template,       :controller => 'user/show_news_posts_template'
    theme.resource :show_artifact_template,         :controller => 'user/show_artifact_template'
    theme.resource :browse_artifacts_template,      :controller => 'user/browse_artifacts_template'
    theme.resource :index_artifacts_template,       :controller => 'user/index_artifacts_template'
    theme.resource :show_author_template,           :controller => 'user/show_author_template'
    theme.resource :show_full_text_template,        :controller => 'user/show_full_text_template'
    theme.resource :show_google_location_template,  :controller => 'user/show_google_location_template'
    theme.resource :layout_template,                :controller => 'user/layout_template'
  end
  
  map.static ':permalink', :controller => 'pages', :action => 'show'
  map.root :visitors
end
