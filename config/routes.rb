Rytp::Application.routes.draw do
  match 'login' => 'admins#login', :as => :login
  match 'logout' => 'admins#logout', :as => :logout
  match 'not_approved' => 'admins#not_approved', :as => :not_approved
  match ':id/approve' => 'admins#approve', :as => :approve
  resources :admins

  match 'index' => 'poops#index', :as => :index
  match 'rytpmv' => 'poops#rytpmv', :as => :rytpmv
  match 'top/:category' => 'poops#top', :as => :top
  match 'add_poop' => 'poops#new', :as => :add_poop
  match ':id' => 'poops#show', :as => :watch, :constraints => { :id => /\d+/ }
  match ':id/good' => 'poops#vote', :as => :vote_poop, :constraints => { :id => /\d+/ }
  match ':id/bad' => 'poops#vote_bad', :as => :vote_bad, :constraints => { :id => /\d+/ }
  resources :poops

  match 'wiki' => 'static#wiki', :as => :wiki
  match 'study' => 'static#study', :as => :study

  match 'feed' => 'rss#index', :as => :rss_feed

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "poops#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id(.:format)))'
end
