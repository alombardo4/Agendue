Agendue::Application.routes.draw do

  resources :notifications

  get "agendue_calendar/show"
  get "agendue_calendar/ics"
  resources :personal_tasks
  get 'personal_tasks/all/complete' => 'personal_tasks#complete'
  get 'personal_tasks/all/incomplete' => 'personal_tasks#incomplete'

  resources :premium_users

  resources :devices

  resources :helps

    root 'home#home'

  get "password_resets/new"
  get 'index' => 'static#home'
  get 'users/new' =>'users#new'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  get 'projects/:id/empty_wiki' => 'projects#empty_wiki'
  post 'projects/:id/removeshare' => 'projects#removeshare', as: :removeshare
  get 'projects/:id/messages' => 'projects#allmessages', as: :project_messages
  get 'projects/:id/public' => 'projects#show_public', as: :project_show_public
  get '/projects/shares' => 'projects#shares', as: :projects_shares_OLD
  get 'projects/:id/shares' => 'projects#shares', as: :project_shares
  get '/tasks/assigned' => 'tasks#assigned', as: :your_tasks
  get '/tasks/calendar' => 'agendue_calendar#show_old', as: :old_calendar
  get '/calendar' => 'agendue_calendar#show', as: :tasks_calendar
  get '/home' => 'static#home'
  get '/contact' => 'static#contact'
  get '/about' => 'static#about'
  get '/privacy' => 'static#privacy'
  get '/termsandconditions' =>'static#termsandconditions'

  get 'admin' => 'admin#index'
  get 'landing' => 'landing#index'
  get 'landing/score' => 'landing#score'
  get 'landing/personal' => 'landing#personal'
  get 'landing/incomplete_count' => 'landing#incomplete_count'
  match '/auth/:provider/callback', :to => 'sessions#create', via: [:get]
  match '/auth/failure', :to => 'sessions#failure', via: [:get]

  get 'userinfo' => 'users#show'
  get '/user' => 'users#show', as: :just_user
  get 'projects/copy' => 'projects#copy_start', as: :copystart
  get 'projects/:id/copy' => 'projects#copy_options', as: :copyname
  post 'projects/:id/copy' => 'projects#copy_run', as: :copy
  post 'messages' => 'messages#create', as: :messages
  get 'projects/:id/wiki' => 'projects#showwiki', as: :show_wiki
  get 'projects/:id/wiki/edit' => 'projects#editwiki', as: :edit_project_wiki
  post 'projects/:id/wiki/edit' => 'projects#updateprojectwiki', as: :project_wiki
  get 'projects/:id/tasks/complete' => 'projects#complete_tasks', as: :project_complete_tasks
  get 'projects/:id/tasks/incomplete' => 'projects#incomplete_tasks', as: :project_incomplete_tasks
  get 'projects/:id/tasks' => 'projects#tasks', as: :project_tasks
  get 'projects/:id/shares/canshare' => 'projects#canshare', as: :project_can_share
  get 'projects/:id/shares' => 'projects#shares'
  get 'oauthpassword' => 'sessions#oauthpassword', as: :oauthpassword
  get 'tour' => 'newusertour#tour', as: :tour
  get 'help' => 'helps#index', as: :all_help
  get 'tasks/assigned/complete' => 'tasks#assignedcomplete', as: :complete_assigned_tasks
  get 'tasks/assigned/incomplete' => 'tasks#assignedincomplete', as: :incomplete_assigned_tasks
  get 'tasks/complete' => 'tasks#allcomplete', as: :complete_tasks
  get 'tasks/incomplete' => 'tasks#allincomplete', as: :incomplete_tasks
  get 'tasks/labels' => 'tasks#labels', as: :task_labels
  get 'calendar/feed/:id/:hash' => 'agendue_calendar#ics', as: :calendar_ics
  get 'admin/addpremium' => 'admin#createpremiumoverride', as: :create_premium_override
  post 'admin/addpremium' => 'admin#addpremiumoverride', as: :add_premium_override
  get 'admin/showpremium' => 'admin#showpremiumoverride', as: :show_premium_override
  get 'charges/explainfeatures' => 'charges#explainfeatures', as: :explainfeatures
  get 'atlanta' => 'static#atlanta', as: :atlanta
  get 'acknowledgements' => 'static#acknowledgements', as: :acknowledgements

  #analytics
  get 'projects/:id/analytics' => 'analytics#index', as: :project_analytics
  get 'projects/:id/analytics/status' => 'analytics#status', as: :analytics_status
  get 'projects/:id/analytics/tasks_per_user' => 'analytics#tasks_per_user', as: :analytics_tasks_per_user
  get 'projects/:id/analytics/tasks_complete_per_user' => 'analytics#tasks_complete_per_user', as: :analytics_tasks_complete_per_user
  get 'projects/:id/analytics/percent_complete' => 'analytics#percent_complete', as: :analytics_percent_complete

  resources :admin

  resources :help

  resources :charges

  resources :users

  resources :tasks

  resources :projects

  resources :sessions

  resources :password_resets
end
