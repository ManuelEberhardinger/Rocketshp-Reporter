class InstagramController < ApplicationController
  CALLBACK_URL = 'https://quiet-peak-67098.herokuapp.com/instagram/callback'.freeze

  # GET /instagram
  def index
    @company = current_company

    # if logged in and auth hash is valid, data can be received
    if session['instagram_auth_hash']
      client = Instagram.client(:access_token => session['instagram_auth_hash'])
      # get the recent media of loggend in user (max 20)
      @return = client.user_recent_media
      @face = 'You are logged in! <a href="/instagram/logout">Logout</a>'
    # otherwise redirect to login
    else
      redirect_to '/instagram/login_page'
    end
  # if a exception appears, logout and show message
  rescue => error
    logout(error.message)
  end

  # GET /instagram/login_page
  def login_page
  end

  # login into instagram, will redirect you to the instagram login page
  def login
    # config the instagram client with key and secret
    Instagram.configure do |config|
      config.client_id = Rails.application.secrets.instagram_api_key
      config.client_secret = Rails.application.secrets.instagram_api_secret
    end
    redirect_to Instagram.authorize_url(redirect_uri: CALLBACK_URL)
  end

  # callback from the omniauth authentication
  def callback
    response = Instagram.get_access_token(params[:code], redirect_uri: CALLBACK_URL)
    session['instagram_auth_hash'] = response.access_token
    redirect_to '/instagram'
  end

  # set instagram session to nil, so you have to login again next time
  # display message if available
  def logout(message = nil)
    session['instagram_auth_hash'] = false
    if message.blank?
      redirect_to '/instagram/login_page'
    else
      redirect_to '/instagram/login_page', notice: message
    end
  end
end
