Rails.application.routes.draw do
  resources :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Root of your site with "root"
  root 'pages#home'

  # Regular routes:
  #   get 'products/:id' => 'catalog#view'
  get 'pages/secure'

  # Named routes, that can be invoked with purchase_url(id: product.id):
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Resource routes (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Resource routes with options:
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

  # Resource routes with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Resource routes with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Resource routes with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Resource routes within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
