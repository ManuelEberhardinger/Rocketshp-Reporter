class TwitterController < ApplicationController
  def index
    @company = current_company

    if session['twitter_auth_hash']
      @face = 'You are logged in! <a href="/twitter/logout">Logout</a>'
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key = ENV['TWITTER_API_KEY']
        config.consumer_secret     = ENV['TWITTER_API_SECRET']
        config.access_token        = auth_hash['token']
        config.access_token_secret = auth_hash['secret']
      end
      @timeline = @client.home_timeline
    else
      redirect_if_not_logged_in
    end
  rescue => error
    redirect_if_not_logged_in(error.message)
  end

  def logout
    session['twitter_auth_hash'] = nil
    redirect_to 'twitter/login_page'
  end

  def redirect_if_not_logged_in(message = nil)
    session['twitter_auth_hash'] = nil
    if message.blank?
      redirect_to '/twitter/login_page'
    else
      redirect_to '/twitter/login_page', notice: message
    end
  end

  def login_page
  end

  def callback
    auth_hash
    # not supported right now
    # @@ads_client = TwitterAds::Client.new(
    #   Rails.application.secrets.twitter_api_key,
    #   Rails.application.secrets.twitter_api_secret,
    #   auth_hash.token,
    #   auth_hash.secret
    # )

    redirect_to '/twitter'
  end

  def auth_hash
    session['twitter_auth_hash'] ||= request.env['omniauth.auth'].credentials
  end
end
