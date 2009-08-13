ActionController::Routing::Routes.draw do |map|
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'
  map.admin 'admin', :controller => 'admin', :action => 'show'
  
  map.resource :account, :controller => "users"
  map.resource :user_session

  map.resources :visitors
  
  map.resources :users
  map.resources :password_resets
  
  map.www_root '', :controller => :visitors, :action => :index, :conditions => { :subdomain => /www/ }
  map.site_root '', :controller => 'sites', :action => "show", :conditions => { :subdomain => /.+/ }
  map.resources :items, :authors, :categories, :document_types, :memberships, :news_posts
  map.resource :browse, :about, :sitestyle, :featured_item
  
  map.resources :sites, :has_many => [:items, :authors, :categories, :document_types, :memberships, :news_posts], :has_one => [:browse, :about, :sitestyle, :featured_item]

  map.resources :items do |item| 
    item.resource :full_text
    item.resource :google_location
  end

  map.resources :sites do |site| 
    site.resources :items do |item| 
      item.resource :full_text
      item.resource :google_location
    end 
  end
  
  map.root :visitors
end
