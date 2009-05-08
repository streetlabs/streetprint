ActionController::Routing::Routes.draw do |map|
  map.resources :items

  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'
  
  map.resource :account, :controller => "users"
  map.resource :user_session
  
  map.resources :users
  map.resources :password_resets
  map.resources :items
  
  map.root :controller => "user_sessions", :action => "new"
end
