class LinkedinController < ApplicationController
  def index
    if session['linkedin_auth_hash'] && defined? @@client
      @face = 'You are logged in! <a href="/linkedin/logout">Logout</a><br>'
      @all_companies = @@client.company(is_admin: 'true')
      @id = @all_companies.all[0].id
      @return = @@client.profile
    else
      redirect_if_not_logged_in
    end
  #rescue
  #  redirect_if_not_logged_in
  end

  def login_page
    @face = '<a href="/auth/linkedin">Login</a>'
  end

  def logout
    redirect_if_not_logged_in
  end

  def redirect_if_not_logged_in
    @@client = nil
    session['linkedin_auth_hash'] = nil
    redirect_to '/linkedin/login_page'
  end

  def callback
    auth_hash
    @@client = LinkedIn::API.new(auth_hash["token"])
    redirect_to '/linkedin'
  end

  def auth_hash
    session['linkedin_auth_hash'] ||= request.env['omniauth.auth'].credentials
  end
end
