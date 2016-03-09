class FacebookController < ApplicationController
  SITE_URL = 'http://localhost:3000/'.freeze

  def index
    if session['access_token']
      @face = 'You are logged in! <a href="/facebook/logout">Logout</a><br>'
      @graph = Koala::Facebook::API.new(session['access_token'])
      pages = @graph.get_object('me/accounts')
      @page = pages[0]
      get_page_fans_adds_removes
      @all_likes = FacebookLike.where("date >= ?", Date.parse("2016-02-01"))
    else
      redirect_to '/facebook/login_page'
    end
  end

  def create_report
    redirect_to '/facebook/report.pdf'
  end

  def report
    @all_likes = FacebookLike.where("date >= ?", Date.parse("2016-02-01"))
    respond_to do |format|
      format.pdf do
        render  pdf: 'report',
                layout: 'layouts/pdf.html',
                template:'facebook/index.pdf.erb',
                javascript_delay: 3000
      end
    end
  end

  def login_page
    @face = '<a href="/facebook/login">Login</a>'
  end

  def login
    # generate a new oauth object with your app data and your callback url
    @@oauth = Koala::Facebook::OAuth.new(SITE_URL + 'facebook/callback')

    # redirect to facebook to get your code
    redirect_to @@oauth.url_for_oauth_code
  end

  def logout
    @@oauth = nil
    session['access_token'] = nil
    redirect_to '/facebook'
  end

  # method to handle the redirect from facebook back to you
  def callback
    # get the access token from facebook with your code
    session['access_token'] = @@oauth.get_access_token(params[:code])
    redirect_to '/facebook'
  end

  def get_page_fans_adds_removes
    likes = @graph.get_object(@page['id'] + '/insights/page_fans,page_fan_adds,page_fan_removes')
    size = likes[0]['values'].length
    size.times do |i|
      single_like = FacebookLike.new
      single_like.date = Date.parse(likes[0]['values'][i]['end_time'])
      single_like.page_id = @page['id']
      likes.each do |element|
        single_like[element['name']] = element['values'][i]['value']
      end
      single_like.save
    end
  end
end
