authorization do
  role :guest do
    has_permission_on [:users, :trainings], :to => :read
    has_permission_on :users, :to => [:new, :create]
  end
  
  role :member do
    includes :guest
    has_permission_on :races, :to => :manage do
      if_attribute :user => is {user}
    end
    
    has_permission_on :trainings, :to => :manage do
      if_attribute :user => is {user}
    end
    has_permission_on :users, :to => [:new, :edit, :create, :update] do
      if_attribute :id => is {user.id}
    end
  end
  
  role :admin do
    
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