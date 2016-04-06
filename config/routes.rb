Rails.application.routes.draw do
  resources :contacts
  resources :companies
  resources :users

  root 'companies#index'

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
  get 'twitter/logout'

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

  get 'login' => 'sessions#new'
  post   'login'   => 'sessions#create'
  get 'logout'  => 'sessions#destroy'
end
