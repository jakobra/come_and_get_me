ComeAndGetMe::Application.routes.draw do
  resources :images do
    member do
      get 'original'
      get 'medium'
      get 'small'
      get 'thumbnail'
    end
  end
  
  match '/assets/images/:id/:action.*file_name', :controller => 'images'
  
  resources :menu_nodes
  resources :side_modules
  resources :pages
  
  resources :counties do
    resources :tracks, :only => [:index]
    
    resources :municipalities, :shallow => true do
      resources :tracks, :only => [:index]
    end
  end
  
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login
  match 'register' => 'users#create', :as => :register
  match 'signup' => 'users#new', :as => :signup
  
  match 'session' => 'sessions#create', :as => :open_id_complete
  
  resources :users do
    member do
      get 'statistics'
      put 'admin'
      get 'records'
      get 'events'
    end
    
    resources :trainings, :shallow => true do
      resources :races, :shallow => true
    end
  end
  
  match 'users/:login/track_statistics/:track_id' => 'users#track_statistics', :as => :user_track_statistics
  match 'users/:login/track_statistics_data/:track_id' => 'users#track_statistics_data', :as => :user_track_statistics_data
  
  resource :session, :only => [:new, :create, :destroy]
  
  resources :tracks do
    member do
      get 'records'
      get 'file'
    end
    
    get 'recent_track_records', :on => :collection

    resources :tracksegments, :only => [:new, :create]
    resources :points, :only => :index
  end
  
  match '/content/tracks/:id.*file_name' => 'tracks#file', :as => :track_file
  
  match 'javascripts/load_all_tracks' => 'javascripts#load_all_tracks'
  
  root :to => 'home#index'
  
  match "info/:permalink" => 'pages#show', :as => :static
  
  match ':login' => 'users#show', :as => :member

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
