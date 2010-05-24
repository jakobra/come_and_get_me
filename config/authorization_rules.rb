authorization do
  role :guest do
    has_permission_on [:trainings, :municipalities, :counties], :to => :read
    has_permission_on :users, :to => :read do
      if_attribute :id => is_not {APP_CONFIG['admin_user']}
    end
    has_permission_on :users, :to => [:new, :create, :statistics, :records, :track_statistics]
    has_permission_on :comments, :to => :report
    has_permission_on :pages, :to => :show
    has_permission_on :tracks, :to => [:read, :records, :recent_track_records]
  end
  
  role :member do
    has_permission_on :races, :to => :manage do
      if_attribute :user => is {user}
    end
    
    has_permission_on :trainings, :to => :manage do
      if_attribute :user => is {user}
    end
    
    has_permission_on :users, :to => [:edit, :update] do
      if_attribute :id => is {user.id}
    end
    
    has_permission_on :tracks, :to => [:new, :edit, :create, :update]
    has_permission_on :comments, :to => [:new, :create]
    
    has_permission_on :comments, :to => [:edit, :update] do
      if_attribute :user => is {user}
    end
  end
  
  role :admin do
    has_permission_on [:users, :comments, :pages, :side_modules, :menu_nodes, :trainings, :images], :to => [:manage, :read]
    has_permission_on [:municipalities, :counties], :to => :manage
    has_permission_on :tracks, :to => :destroy
  end
end

privileges do
  privilege :manage do
    includes :new, :edit, :create, :update, :destroy
  end
  
  privilege :read do
    includes :show, :index
  end
end