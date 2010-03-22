ActionController::Routing::Routes.draw do |map|
  map.resources :pages

  map.resources :comments, :only => [:index, :edit, :update], :member => {:approve => :put, :report => :get} do |comments|
    comments.resources :comments, :only => [:new, :create]
  end
  
  map.resources :counties do |county|
    county.resources :tracks, :only => [:index]
    county.resources :race_tracks, :only => [:index]
    
    county.resources :municipalities, :shallow => true do |municipality|
      municipality.resources :tracks, :only => [:index]
      municipality.resources :race_tracks, :only => [:index]
    end
  end
  
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  
  map.login '/login', :controller => 'sessions', :action => 'new'
  
  map.register '/register', :controller => 'users', :action => 'create'
  
  map.signup '/signup', :controller => 'users', :action => 'new'
  
  map.open_id_complete 'session', :controller => 'sessions', :action => 'create', :requirements => {:method => :get}
  
  map.resources :users, :member => {:statistics => :get, :admin => :put} do |users|
    users.resources :trainings, :shallow => true do |trainings|
      trainings.resources :comments, :only => [:new, :create]
      trainings.resources :races, :shallow => true, :collection => {:edit_individual => :post, :update_individual => :put} do |races| 
        races.resources :comments, :only => [:new, :create]
      end
    end
  end
  
  map.resources :race_tracks, :member => {:records => :get} do |race_tracks|
    race_tracks.resources :comments, :only => [:new, :create]
  end
  
  map.resource :session, :only => [:new, :create, :destroy]
  
  map.resources :emails, :except => "new", :member => {:parse_gpx => :get}
  
  map.resources :tracks do |tracks|
    tracks.resources :tracksegments, :only => [:new, :create]
    tracks.resources :comments, :only => [:new, :create]
    tracks.resources :points, :only => :index
  end
  
  map.root :controller => "home"
  
  map.static "static/:permalink", :controller => :pages, :action => :show
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.member ':login', :controller => :users, :action => :show
end
