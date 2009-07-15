ActionController::Routing::Routes.draw do |map|
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'
  map.admin 'admin', :controller => 'admin', :action => 'show'
  
  map.resource :account, :controller => "users"
  map.resource :user_session
  
  map.resources :users
  map.resources :password_resets
  map.resources :sites, :has_many => [:items, :authors, :categories, :document_types, :memberships, :news_posts], :has_one => [:browse, :about, :sitestyle]

  map.resources :sites do |site| 
    site.resources :items do |item| 
      item.resource :full_text
    end 
  end 
  
  map.root :login
end
