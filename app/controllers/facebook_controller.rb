class FacebookController < ApplicationController
  SITE_URL = 'http://localhost:3000/'.freeze

  def index
    if session['access_token']
      @face = 'You are logged in! <a href="/facebook/logout">Logout</a><br>'
      @@graph = Koala::Facebook::API.new(session['access_token'])
      @@page = @@graph.get_object('me/accounts')[0]
      get_insights_variables
    else
      redirect_to '/facebook/login_page'
    end
  end

  def get_insights_variables
    name = @@page['id']
    FacebookInsights.connect_with_mongodb

    if FacebookInsights.collection_exists?(name) == false
      fresh_up_data_without_redirect
    end

    @all_fans = FacebookInsights.get_single_metric(name, 'page_fans')
    @page_adds = FacebookInsights.get_single_metric(name, 'page_fan_adds')
    @page_removes = FacebookInsights.get_single_metric(name, 'page_fan_removes')
    @likes_net = @page_adds.merge(@page_removes) { |_k, a_value, b_value| a_value - b_value }
    @page_impressions = FacebookInsights.get_single_metric(name, 'page_impressions')
    FacebookInsights.close_connection
  end

  def fresh_up_data
    insights = @@graph.get_object(@@page['id'] + '/insights?since=2016-02-01&until=2016-03-01')
    FacebookInsights.fresh_up_data(@@page['id'], insights)
    redirect_to '/facebook'
  end

  def fresh_up_data_without_redirect
    insights = @@graph.get_object(@@page['id'] + '/insights?since=2016-02-01&until=2016-03-01')
    FacebookInsights.fresh_up_data(@@page['id'], insights)
  end

  def report
    get_description_from_params
    FacebookInsights.connect_with_mongodb
    get_insights_variables
    FacebookInsights.close_connection
    respond_to do |format|
      format.pdf do
        render  pdf: 'report',
                layout: 'layouts/pdf.html',
                template: 'facebook/index.pdf.erb',
                javascript_delay: 3000,
                :margin => {:top                => 15,
                            :bottom             => 10,
                            :left               => 20,
                            :right              => 20}
      end
    end
  end

  def get_description_from_params
    @description_all_fans = params[:description_all_fans]
    @description_likes_unlikes = params[:description_likes_unlikes]
    @description_page_impressions = params[:description_page_impressions]
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
end
