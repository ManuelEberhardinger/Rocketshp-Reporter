Rails.application.routes.draw do


  resources :contacts
  resources :companies
  get 'facebook' => 'facebook#index'
  get 'twitter' => 'twitter#index'
  get 'google_analytics' => 'google_analytics#index'
  get 'linkedin' => 'linkedin#index'
  get 'instagram' => 'instagram#index'

  get 'facebook/login'
  get 'facebook/logout'
  get 'facebook/callback'
  get 'facebook/login_page'
  post 'facebook/report'
  get 'facebook/fresh_up_data'
  get 'facebook/options'

  get 'twitter/login_page'
  get 'auth/twitter/callback' => 'twitter#callback'

  get 'linkedin/login_page'
  get 'auth/linkedin/callback' => 'linkedin#callback'
  get 'linkedin/logout'

  get 'instagram/login_page'
  get 'instagram/callback'
  get 'instagram/logout'
  get 'instagram/login'

  get 'google_analytics/login_page'
  get 'auth/google_oauth2/callback' => 'google_analytics#callback'
  get 'google_analytics/logout'
  get 'google_analytics/fresh_up_data'
  post 'google_analytics/report'
  get 'google_analytics/options'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
