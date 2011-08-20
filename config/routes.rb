Rytp::Application.routes.draw do
  # authorization
  match 'auth/:provider/callback', :to => 'sessions#create'
  match 'auth/failure', :to => 'sessions#failure'
  match 'logout', :to => 'sessions#destroy'

  # admin resources
  resources :admin, :except => [:new, :create] do
    member do
      delete :poops
      delete :votes
    end
  end
  match 'admin' => 'admin#index'

  # news and contests
  resources :news
  resources :contests

  # profile
  match 'profile/:id' => 'users#show', :as => :profile, :via => :get
  resources :users, :only => [:edit, :update], :path => 'profile'

  # poops pages
  match 'search' => 'poops#search', :as => :search
  match 'rytpmv' => 'poops#rytpmv', :as => :rytpmv
  match 'top/:category(/:period)' => 'poops#top', :as => :top

  # approve path
  match ':id/approve' => 'poops#approve', :as => :approve

  # default watch path
  match ':id' => 'poops#show', :as => :watch, :constraints => { :id => /\d+.*/ }

  # add_poop and not_approved paths
  match 'add_poop' => 'poops#new', :as => :add_poop
  match 'not_approved' => 'poops#not_approved', :as => :not_approved

  # voting path
  match 'vote/positive/:id', :to => 'votes#positive', :as => :vote_positive
  match 'vote/negative/:id', :to => 'votes#negative', :as => :vote_negative

  # favourites path
  match 'favourites/add/:id', :to => 'favourites#add', :as => :add_to_favourites
  match 'favourites/remove/:id', :to => 'favourites#remove', :as => :remove_from_favourites

  # poops resources
  resources :poops, :except => :new

  # static pages
  match 'wiki' => 'static#wiki', :as => :wiki
  match 'rules' => 'static#rules', :as => :rules
  match 'howto' => 'static#howto', :as => :howto
  match 'info' => 'static#info', :as => :info
  match 'files' => 'static#files', :as => :files

  # feed paths and sitemap
  match 'feed' => 'feed#index', :as => :rss_feed
  match 'feed/:category' => 'feed#poops', :as => :poops_feed
  match 'sitemap' => 'feed#sitemap', :as => :sitemap

  root :to => "poops#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.
end
