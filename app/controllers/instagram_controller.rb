class InstagramController < ApplicationController
  CALLBACK_URL = 'https://quiet-peak-67098.herokuapp.com/instagram/callback'.freeze

  def index
    @company = current_company

    if session['instagram_auth_hash']
      client = Instagram.client(:access_token => session['instagram_auth_hash'])
      @return = client.user_recent_media
      @face = 'You are logged in! <a href="/instagram/logout">Logout</a>'
    else
      redirect_to '/instagram/login_page'
    end
  rescue => error
    logout(error.message)
  end

  def login_page
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

  def logout(message = nil)
    session['instagram_auth_hash'] = false
    if message.blank?
      redirect_to '/instagram/login_page'
    else
      redirect_to '/instagram/login_page', notice: message
    end
  end
end
