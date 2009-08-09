ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'home'

  map.login               'login',                  :controller => 'user_sessions',         :action => 'new'
  map.logout              'logout',                 :controller => 'user_sessions',         :action => 'destroy'
  map.signup              'signup',                 :controller => 'users',                 :action => 'signup'

  map.recent_activity     'recent_activity',        :controller => 'users',                 :action => 'recent_activity'
  map.my_openid			  	  'my_openid',				      :controller => 'users',                 :action => 'third_party'
  map.team_list				    'team_list',				      :controller => 'groups',                :action => 'team_list'
  map.team_roster			    'team_roster',				    :controller => 'schedules',             :action => 'team_roster'
  map.team_no_show			  'team_no_show',				    :controller => 'schedules',             :action => 'team_no_show'
  map.marker_list			    'marker_list',				    :controller => 'markers',               :action => 'marker_list'
  map.fichar              'matches/:id/set_team',   :controller => 'matches',               :action => 'set_team'
  
  map.manage_join   'teammates/:id/manage_join/:teammate',    :controller => 'teammate',    :action => 'manage_join'
  
  
  
  map.resources   :user_sessions,   :as => 'try_again'

  map.resources   :users,           :as => 'jugadores',       :collection  => { :list => :get, :recent_activity => :get, :search => :get }  
  map.resources   :schedules,       :as => 'eventos',         :collection  => { :list => :get, :search => :get }          
  map.resources   :groups,          :as => 'equipos',         :collection  => { :list => :get, :search => :get }
  map.resources   :markers,         :as => 'centros'
  map.resources   :scorecards,      :as => 'classificaciones'
  map.resources   :matches,         :as => 'jornadas'

  # map.resources :users  
  map.resources :teammates
  # map.resources :groups
  # map.resources :markers
  # map.resources :matches
  # map.resources :messages
  map.resources :posts
  # map.resources :schedules
  # map.resources :scorecards
  map.resources :topics
  map.resources :forums
  map.resources :entries
  map.resources :comments
  map.resources :blogs
  map.resources :types
  map.resources :sports
  map.resources :roles

  
  map.resources :connections
  map.resources :messages, :collection => { :sent => :get, :trash => :get }
  # , :member => { :reply => :get, :undestroy => :put }

  map.resources :users do |user|
    user.resources :messages
  end



  map.resources :blogs do |blog|
    blog.resources :posts do |post|
      post.resources :comments
    end
  end

  map.resources :forums do |forums|
    forums.resources :topics do |topic|
      topic.resources :posts
    end
  end


  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end