authorization do
  role :guest do
    has_permission_on [:users, :trainings], :to => :read
    has_permission_on :users, :to => [:new, :create, :statistics]
    has_permission_on :comments, :to => :report
    has_permission_on :pages, :to => :show
    has_permission_on :tracks, :to => :read
  end
  
  role :member do
    includes :guest
    has_permission_on :races, :to => :manage do
      if_attribute :user => is {user}
    end
    
    has_permission_on :trainings, :to => :manage do
      if_attribute :user => is {user}
    end
    
    has_permission_on :users, :to => [:edit, :update] do
      if_attribute :id => is {user.id}
    end
    
    has_permission_on :tracks, :to => :manage
    has_permission_on :comments, :to => [:new, :create]
    
    has_permission_on :comments, :to => [:edit, :update] do
      if_attribute :user => is {user}
    end
  end
  
  role :admin do
    has_permission_on [:comments, :pages], :to => [:manage, :read]
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