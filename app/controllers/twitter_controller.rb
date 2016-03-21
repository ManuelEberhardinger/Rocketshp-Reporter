class TwitterController < ApplicationController
  def index
    if session['twitter_auth_hash'] && defined? @@client
      @face = @@client.home_timeline
    else
      session['twitter_auth_hash'] = nil
      redirect_to '/twitter/login_page'
    end
  end

  def login_page
    @face = '<a href="/auth/twitter">Login</a>'
  end

  def callback
    @@client = Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.secrets.twitter_api_key
      config.consumer_secret     = Rails.application.secrets.twitter_api_secret
      config.access_token        = auth_hash.token
      config.access_token_secret = auth_hash.secret
    end

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
