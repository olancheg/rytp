Rytp::Application.routes.draw do

  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'
  match '/logout', :to => 'sessions#destroy'

  resources :news

  resources :admin

  match 'profile/:id' => 'users#show', :as => :profile, :via => :get
  resources :users, :only => [:edit, :update], :path => 'profile'

  match 'search' => 'poops#search', :as => :search
  match 'rytpmv' => 'poops#rytpmv', :as => :rytpmv
  match 'top/:category(/:period)' => 'poops#top', :as => :top

  match ':id/approve' => 'poops#approve', :as => :approve
  match ':id' => 'poops#show', :as => :watch, :constraints => { :id => /\d+.*/ }

  match 'add_poop' => 'poops#new', :as => :add_poop
  match 'not_approved' => 'poops#not_approved', :as => :not_approved
  match 'vote/positive/:id', :to => 'votes#positive', :as => :vote_positive
  match 'vote/negative/:id', :to => 'votes#negative', :as => :vote_negative
  resources :poops, :except => :new

  match 'wiki' => 'static#wiki', :as => :wiki
  match 'rules' => 'static#rules', :as => :rules
  match 'howto' => 'static#howto', :as => :howto
  match 'info' => 'static#info', :as => :info
  match 'files' => 'static#files', :as => :files

  match 'feed' => 'feed#index', :as => :rss_feed
  match 'feed/:category' => 'feed#poops', :as => :poops_feed
  match 'sitemap' => 'feed#sitemap', :as => :sitemap_path

  root :to => "poops#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.
end
