Sp5::Application.routes.draw do

  # Rails 4.2 requires specifying HTTP methods for match
  match "login" => "user_sessions#new", :as => :login, :via => [:get, :post]
  match "logout" => "user_sessions#destroy", :as => :logout, :via => [:get, :delete]
  get '/register/:activation_code' => 'visitor/activations#new', :as => :register
  post '/activate/:id' => 'visitor/activations#create', :as => :activate
  get 'admin' => 'user/my_sites#show', :as => :admin
  get 'superadmin' => 'superadmin#index', :as => :superadmin

  # Subdomain routing
  constraints(Subdomain) do
    get '' => 'visitor/sites#show', :as => :site_root
  end
  get '' => 'visitor/visitors#index', :as => :www_root

  resources :users
  resources :password_resets, :controller => 'user/password_resets'
  resources :visitors, :controller => 'visitor/visitors'
  resources :pages

  resource :streetprint_settings
  resource :user_session
  resource :account, :controller => "users"
  resource :sites_administration, :controller => "sites_administration"

  ## require a site in subdomain
  resources :items, :controller => 'visitor/items', :only => [:index, :show] do
    resource :google_location, :controller => 'visitor/google_locations', :only => :show
    resource :full_text, :controller => 'visitor/full_texts', :only => :show
  end
  # Admin routes - all nested under /admin/:site_id
  scope '/admin/:site_id', :as => 'admin' do
    resources :items, :controller => 'user/items', :as => 'items' do
      resource :google_location, :controller => 'user/google_locations'
      resource :full_text, :controller => 'user/full_texts'
    end

    resources :authors, :controller => 'user/authors', :as => 'authors'

    resources :narratives, :controller => 'user/narratives', :as => 'narratives' do
      collection do
        get :search
      end
    end

    resources :news, :controller => 'user/news_posts', :as => 'news'
    resources :categories, :controller => 'user/categories'
    resources :document_types, :controller => 'user/document_types'
    resources :custom_data_types, :controller => 'user/custom_data_types'
    resources :memberships, :controller => 'user/memberships'
    resources :custom_datas, :controller => 'user/custom_datas'

    resource :site, :controller => 'user/sites', :except => :show
    resource :theme, :controller => 'user/sitethemes', :as => 'theme'
    resource :featured_item, :controller => 'user/featured_items'
    resource :publish_item, :controller => 'user/publish_items'
  end

  # Keep old routes for backward compatibility during transition
  resources 'itemadmin', :controller => 'user/items' do
    resource :google_location, :controller => 'user/google_locations'
    resource :full_text, :controller => 'user/full_texts'
  end
  resources 'authoradmin', :controller => 'user/authors'
  resources 'narrativeadmin', :controller => 'user/narratives' do
    collection do
      get :search
    end
  end
  resources 'newsadmin', :controller => 'user/news_posts'
  resources :categories, :controller => 'user/categories'
  resources :document_types, :controller => 'user/document_types'
  resources :custom_data_types, :controller => 'user/custom_data_types'
  resources :memberships, :controller => 'user/memberships'
  resources :custom_datas, :controller => 'user/custom_datas'
  resource :sitestyle, :controller => 'user/sitethemes'
  resource :featured_item, :controller => 'user/featured_items'
  resource :publish_item, :controller => 'user/publish_items'

  # Visitor routes
  resources :authors, :controller => 'visitor/authors', :only => :show
  resources :narratives, :controller => 'visitor/narratives', :only => [:index, :show]
  resources :news_posts, :controller => 'visitor/news_posts', :only => :index
  resource :browse, :controller => 'visitor/browses'
  resource :about, :controller => 'visitor/abouts'

  # Old siteadmin routes for backward compatibility
  resources 'siteadmin', :except => :show, :controller => 'user/sites' do
    resources 'itemadmin', :controller => 'user/items' do
      resource :google_location, :controller => 'user/google_locations'
      resource :custom_datas, :controller => 'user/custom_datas'
    end

    resources 'authoradmin', :controller => 'user/authors'
    resources 'narrativeadmin', :controller => 'user/narratives'
    resources 'newsadmin', :controller => 'user/news_posts'
    resources :categories, :controller => 'user/categories'
    resources :document_types, :controller => 'user/document_types'
    resources :custom_data_types, :controller => 'user/custom_data_types'
    resources :memberships, :controller => 'user/memberships'

    resource :sitestyle, :controller => 'user/sitethemes'
    resource :featured_item, :controller => 'user/featured_items'
    resource :publish_item, :controller => 'user/publish_items'
  end
  # visitor paths like /sites/1/items/2/google_location. urls like revrom.streetprint.org/items/2/google_location handled above
  resources :sites, :controller => 'visitor/sites' do
    resources :items, :controller => 'visitor/items', :only => [:index, :show] do
      resource :google_location, :controller => 'visitor/google_locations', :only => :show
      resource :custom_datas, :controller => 'user/custom_datas', :only => :show
      resource :full_text, :controller => 'visitor/full_texts', :only => :show
    end

    resources :authors, :controller => 'visitor/authors', :only => :show
    resources :narratives, :controller => 'visitor/narratives', :only => [:index, :show]
    resources :news_posts, :controller => 'visitor/news_posts', :only => [:index, :show]

    resource :browse, :controller => 'visitor/browses'
    resource :about, :controller => 'visitor/abouts'
  end


  resources :site_themes, :controller => 'user/site_themes' do
    resource :show_site_template, :controller => 'user/show_site_template'
    resource :show_about_template, :controller => 'user/show_about_template'
    resource :show_news_posts_template, :controller => 'user/show_news_posts_template'
    resource :show_artifact_template, :controller => 'user/show_artifact_template'
    resource :browse_artifacts_template, :controller => 'user/browse_artifacts_template'
    resource :index_artifacts_template, :controller => 'user/index_artifacts_template'
    resource :index_narratives_template, :controller => 'user/index_narratives_template'
    resource :show_narrative_template, :controller => 'user/show_narrative_template'
    resource :show_author_template, :controller => 'user/show_author_template'
    resource :show_full_text_template, :controller => 'user/show_full_text_template'
    resource :show_google_location_template, :controller => 'user/show_google_location_template'
    resource :layout_template, :controller => 'user/layout_template'
  end

  # Catch-all route for static pages - exclude asset directories and system paths
  get ':permalink' => 'pages#show',
      :as => :static,
      :constraints => { :permalink => /(?!stylesheets|javascripts|images|system|assets).*/ }
  root :to => 'visitor/visitors#index'
end
