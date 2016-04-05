class TwitterController < ApplicationController
  def index
    session[:twitter_company_id] = params[:id] unless params[:id].blank?
    @company = Company.find(session[:twitter_company_id])

    if session['twitter_auth_hash']
      @face = 'You are logged in! <a href="/twitter/logout">Logout</a>'
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key = Rails.application.secrets.twitter_api_key
        config.consumer_secret     = Rails.application.secrets.twitter_api_secret
        config.access_token        = auth_hash['token']
        config.access_token_secret = auth_hash['secret']
      end
      @timeline = @client.home_timeline
    else
      redirect_if_not_logged_in
    end
  rescue
    redirect_if_not_logged_in
  end

  def logout
    session['twitter_auth_hash'] = nil
    redirect_to '/companies/' + session[:twitter_company_id].to_s
  end

  def redirect_if_not_logged_in
    session['twitter_auth_hash'] = nil
    redirect_to '/twitter/login_page'
  end

  def login_page
    @face = '<a href="/auth/twitter">Login</a>'
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
