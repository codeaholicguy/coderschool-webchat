Rails.application.routes.draw do
  get 'messages/index'

  get 'welcome/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :users
  resources :sessions
  resources :messages

  get 'sign-up' => 'users#new'
  get 'sign-in' => 'sessions#new'
  get 'sign-out' => 'sessions#destroy'

  get 'auth/:provider/callback' => 'sessions#callback'

  get 'friend-request' => 'users#send_friend_request'
  get 'friend-accept' => 'users#accept_friend_request'
  get 'friend-reject' => 'users#reject_friend_request'
  get 'friend-request-cancel' => 'users#cancel_friend_request'
  get 'friend-block' => 'users#block_friend'
  get 'friend-unblock' => 'users#unblock_friend'
  get 'friend-remove' => 'users#remove_friend'

  get 'conversation' => 'messages#show'
  post 'send-message' => 'messages#create'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
