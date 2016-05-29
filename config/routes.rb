Rails.application.routes.draw do

  resources :posts
  resources :contacts
  resources :companies
  resources :users
  resources :time_trackings

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
  get 'linkedin/options'
  post 'linkedin/report'

  get 'instagram/login_page'
  get 'instagram/callback'
  get 'instagram/logout'
  get 'instagram/login'

  get 'google_analytics/login_page'
  get 'auth/google_oauth2/callback' => 'google_analytics#callback'
  get 'google_analytics/logout'
  get 'google_analytics/adwords'
  post 'google_analytics/report'
  post 'google_analytics/adwords_report'
  get 'google_analytics/options'

  get 'login' => 'sessions#new'
  post 'login'   => 'sessions#create'
  get 'logout'  => 'sessions#destroy'

  get 'companies_calendar' => 'companies#calendar'
  get 'client_information' => 'companies#client_information'
  get 'client_contacts' => 'companies#client_contacts'
  get 'content_distribution' => 'companies#content_distribution'
  get 'create_post_report' => 'companies#create_post_report'
end
