Bootstrap::Application.routes.draw do

  get "users/show"

  resources :feedbacks

  #devise_for :admin_users, ActiveAdmin::Devise.config

  get "secure/index"

  get "home/index"
#devise_for :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  devise_for :users,:controllers => { :registrations =>'registration',:passwords =>'password'}
  
  #devise_for controllers: { omniauth_callbacks: "omniauth_callbacks" }

  #resources :users, :only => [:show]
  resources :users do

  end
  get 'users/:id/edit2' => 'users#edit'
  devise_scope :user do match "login" => "registration#step2" end


 

  resources :page
  get '/whatis' => 'page#whatis'
  get '/about' => 'page#about'
  get '/useragreement' => 'page#useragreement'
  get '/privacypolicy' => 'page#privacypolicy'
  get '/cookiepolicy' => 'page#cookiepolicy'
  #match '/ahmad1' => 'page#ahmad1'
  #match  '/ahmad2' => 'page#ahmad2'
  #match  '/ahmad3' => 'page#ahmad3'
  #match  '/ahmad4' => 'page#ahmad4'
  #match  '/ahmad6' => 'page#ahmad6'
  #match  '/ahmad5' => 'page#ahmad5'
  #match  '/ahmad7' => 'page#ahmad7'
  match '/temp' =>'home#temp'
  #atch "/whatis", :controller => "page", :action => "whatis"
  
  resources :user_steps
  match '/user_steps/professional' => 'user_steps#professional'
  match '/user_steps/email' => 'user_steps#email'
  match '/user_steps/authentication' => 'user_steps#authentication'
  match '/user_steps/confirm' => 'user_steps#confirm'
  match '/user_steps/share' => 'user_steps#share'
  match '/user_steps/add' => 'user_steps#add'
  
  # get "home/index"
resources :friendships



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
  #     c
  #
  # ollection do
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.

  root :to => "home#index"

#  match ':controller(/:action(/:id(.:format)))'
  get 'home/index' => 'home#index'

#  get "*any" , :to => "home#index"
end

