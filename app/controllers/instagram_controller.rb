class InstagramController < ApplicationController
  CALLBACK_URL = 'http://localhost:3000/instagram/callback'.freeze

  def index
    session[:instagram_company_id] = params[:id] unless params[:id].blank?
    @company = Company.find(session[:instagram_company_id])

    if session['instagram_auth_hash']
      client = Instagram.client(:access_token => session['instagram_auth_hash'])
      @return = client.user_recent_media
      @face = 'You are logged in! <a href="/instagram/logout">Logout</a>'
    else
      redirect_to '/instagram/login_page'
    end
  rescue
    logout
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
    redirect_to '/instagram'
  end

  def logout
    session['instagram_auth_hash'] = false
    redirect_to '/companies/' + session[:instagram_company_id].to_s
  end
end
