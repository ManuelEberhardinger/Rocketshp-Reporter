class TwitterController < ApplicationController

  # GET /twitter
  def index
    @company = current_company

    # check if there is a valid auth hash stored
    if session['twitter_auth_hash']
      @face = 'You are logged in! <a href="/twitter/logout">Logout</a>'

      # create client with api key and secret and authorize it with the token and secret
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key = ENV['TWITTER_API_KEY']
        config.consumer_secret     = ENV['TWITTER_API_SECRET']
        config.access_token        = auth_hash['token']
        config.access_token_secret = auth_hash['secret']
      end

      # show timeline of user just for testing as we can't get statistics with the normal api
      @timeline = @client.home_timeline
    else
      # redirect to login page as there is no auth hash saved
      redirect_if_not_logged_in
    end
  # redirect to login page as the token is not valid had has to be renewed
  rescue => error
    redirect_if_not_logged_in(error.message)
  end

  # set session to nil so user is logged out
  def logout
    session['twitter_auth_hash'] = nil
    redirect_to '/twitter/login_page'
  end

  # redirect to login and show message if there is one
  def redirect_if_not_logged_in(message = nil)
    session['twitter_auth_hash'] = nil
    if message.blank?
      redirect_to '/twitter/login_page'
    else
      redirect_to '/twitter/login_page', notice: message
    end
  end

  # GET /twitter/login_page
  def login_page
  end

  # callback for the omniauth authentication
  def callback
    auth_hash
    # not supported right now, no access to twitter ads granted
    # @@ads_client = TwitterAds::Client.new(
    #   Rails.application.secrets.twitter_api_key,
    #   Rails.application.secrets.twitter_api_secret,
    #   auth_hash.token,
    #   auth_hash.secret
    # )

    redirect_to '/twitter'
  end

  # get auth_hash from the authentication after omniauth
  def auth_hash
    session['twitter_auth_hash'] ||= request.env['omniauth.auth'].credentials
  end
end
