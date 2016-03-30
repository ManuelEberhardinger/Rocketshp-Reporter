class InstagramController < ApplicationController
  CALLBACK_URL = 'http://localhost:3000/instagram/callback'.freeze

  def index
    if session['instagram_auth_hash'] && defined? @@client
      @return = @@client.user_recent_media({max_timestamp: Time.utc(2016, 3, 1).to_i, min_timestamp: Time.utc(2016, 2, 1).to_i})
      @face = 'You are logged in! <a href="/instagram/logout">Logout</a><br>'
    else
      redirect_to '/instagram/login_page'
    end
    # rescue
    #  redirect_if_not_logged_in
  end

  def login_page
    @face = '<a href="/instagram/login">Login</a>'
  end

  def login
    Instagram.configure do |config|
      config.client_id = Rails.application.secrets.instagram_api_key
      config.client_secret = Rails.application.secrets.instagram_api_secret
      # For secured endpoints only
      # config.client_ips = '<Comma separated list of IPs>'
    end
    redirect_to Instagram.authorize_url(redirect_uri: CALLBACK_URL)
  end

  def callback
    response = Instagram.get_access_token(params[:code], redirect_uri: CALLBACK_URL)
    session['instagram_auth_hash'] = response.access_token
    @@client = Instagram.client(:access_token => session['instagram_auth_hash'])
    redirect_to '/instagram'
  end

  def logout
    session['instagram_auth_hash'] = false
    redirect_to '/instagram/login_page'
  end
end
