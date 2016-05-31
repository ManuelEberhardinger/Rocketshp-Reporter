class FacebookController < ApplicationController
  SITE_URL = 'https://quiet-peak-67098.herokuapp.com/'.freeze

  def index
    @company = current_company

    check_for_page_id_in_session

    if session['fb_access_token'] && session['fb_page_id']
      @face = 'You are logged in! <a href="/facebook/logout">Logout</a>'
      @page = @company.name.split.join
      create_client
      get_insights_variables
      get_all_posts
    elsif session['fb_access_token']
      redirect_to '/facebook/options'
    else
      redirect_to '/facebook/login_page'
    end
  rescue => error
    logout(error.message)
  end

  def check_for_page_id_in_session
    if @company.social_id.facebook_id.blank? && !params[:page_id].blank?
      @company.social_id.facebook_id = params[:page_id]
      session['fb_page_id'] = @company.social_id.facebook_id
      @company.social_id.save!
      fresh_up_data
    elsif @company.social_id.facebook_id
      session['fb_page_id'] = @company.social_id.facebook_id
    else
      session['fb_page_id'] = nil
    end
  end

  def create_client
    @graph = Koala::Facebook::API.new(session['fb_access_token'])
    @pages = @graph.get_object('me/accounts')
  end

  def options
    create_client
  rescue => error
    session['fb_access_token'] = nil
    session['fb_page_id'] = nil
    redirect_to "/facebook/login_page", notice: error.message
  end

  def get_all_posts
    name = @page.to_s + '_posts'

    FacebookInsights.connect_with_mongodb

    if FacebookInsights.collection_exists?(name) == false
      fresh_up_data_without_redirect("")
    end

    @posts = FacebookInsights.find_all(name)

    @posts_likes = {}
    @posts_comments = {}
    @posts_impressions = {}

    @posts.each { |value|
      print "next"
      id = value['id']
      @infos = @graph.get_object(value['id'], :fields => "likes.summary(true),comments.summary(true)")
      @posts_likes[id] = @infos["likes"]["summary"]["total_count"]
      @posts_comments[id] = @infos["comments"]["summary"]["total_count"]
      @posts_impressions[id] = @graph.get_object(value['id'] + '/insights/post_impressions_unique').first['values'].first['value']
    }
    FacebookInsights.close_connection
  end

  def get_insights_variables
    name = @page
    FacebookInsights.connect_with_mongodb

    if FacebookInsights.collection_exists?(name) == false
      fresh_up_data_without_redirect("")
    end

    @all_fans = FacebookInsights.get_single_metric(name, 'page_fans')
    @page_adds = FacebookInsights.get_single_metric(name, 'page_fan_adds')
    @page_removes = FacebookInsights.get_single_metric(name, 'page_fan_removes')
    @page_likes_by_source = FacebookInsights.get_single_metric(name, 'page_fans_by_like_source')
    @likes_net = @page_adds.merge(@page_removes) { |_k, a_value, b_value| a_value - b_value }

    @page_impressions = FacebookInsights.get_single_metric(name, 'page_impressions')
    @page_impressions_paid = FacebookInsights.get_single_metric(name, 'page_impressions_paid')
    @page_impressions_organic = FacebookInsights.get_single_metric(name, 'page_impressions_organic')

    @page_posts_impressions = FacebookInsights.get_single_metric(name, 'page_posts_impressions')
    @page_posts_impressions_paid = FacebookInsights.get_single_metric(name, 'page_posts_impressions_paid')
    @page_posts_impressions_organic = FacebookInsights.get_single_metric(name, 'page_posts_impressions_organic')

    @page_positive_feedback_by_type = FacebookInsights.get_single_metric(name, 'page_positive_feedback_by_type')
    @page_negative_feedback_by_type = FacebookInsights.get_single_metric(name, 'page_negative_feedback_by_type')

    @page_views = FacebookInsights.get_single_metric(name, 'page_views')
    @page_views_login_unique = FacebookInsights.get_single_metric(name, 'page_views_login_unique')
    @page_tab_views_login_top = FacebookInsights.get_single_metric(name, 'page_tab_views_login_top')
    @page_views_external_referrals = FacebookInsights.get_single_metric(name, 'page_views_external_referrals')

    @page_video_views_paid = FacebookInsights.get_single_metric(name, 'page_video_views_paid')
    @page_video_views_organic = FacebookInsights.get_single_metric(name, 'page_video_views_organic')

    @page_video_complete_views_30s_paid = FacebookInsights.get_single_metric(name, 'page_video_complete_views_30s_paid')
    @page_video_complete_views_30s_organic = FacebookInsights.get_single_metric(name, 'page_video_complete_views_30s_organic')

    @page_fans_gender_age = FacebookInsights.get_single_metric(name, 'page_fans_gender_age')
    @page_fans_reached_gender_age = FacebookInsights.get_single_metric_with_period(name, 'page_impressions_by_age_gender_unique', "days_28")
    @page_storytellers_gender_age = FacebookInsights.get_single_metric_with_period(name, 'page_storytellers_by_age_gender', "days_28")

    @page_fans_country = FacebookInsights.get_single_metric(name, 'page_fans_country')
    @page_fans_city = FacebookInsights.get_single_metric(name, 'page_fans_city')
    @page_fans_locale = FacebookInsights.get_single_metric(name, 'page_fans_locale')

    gon.page_fans_country = get_last_element_of_hash @page_fans_country
    gon.page_fans_city = get_last_element_of_hash @page_fans_city
    gon.page_fans_locale = get_last_element_of_hash @page_fans_locale

    @page_impressions_by_country_unique = FacebookInsights.get_single_metric_with_period(name, 'page_impressions_by_country_unique', 'days_28')
    @page_impressions_by_city_unique = FacebookInsights.get_single_metric_with_period(name, 'page_impressions_by_city_unique', 'days_28')
    @page_impressions_by_locale_unique = FacebookInsights.get_single_metric_with_period(name, 'page_impressions_by_locale_unique', 'days_28')

    gon.page_impressions_by_country_unique = get_last_element_of_hash @page_impressions_by_country_unique
    gon.page_impressions_by_city_unique = get_last_element_of_hash @page_impressions_by_city_unique
    gon.page_impressions_by_locale_unique = get_last_element_of_hash @page_impressions_by_locale_unique

    @page_storytellers_by_country = FacebookInsights.get_single_metric_with_period(name, 'page_storytellers_by_country', 'days_28')
    @page_storytellers_by_city = FacebookInsights.get_single_metric_with_period(name, 'page_storytellers_by_city', 'days_28')
    @page_storytellers_by_locale = FacebookInsights.get_single_metric_with_period(name, 'page_storytellers_by_locale', 'days_28')

    gon.page_storytellers_by_country = get_last_element_of_hash @page_storytellers_by_country
    gon.page_storytellers_by_city = get_last_element_of_hash @page_storytellers_by_city
    gon.page_storytellers_by_locale = get_last_element_of_hash @page_storytellers_by_locale

    FacebookInsights.close_connection
  end

  def get_last_element_of_hash(element)
    return element[element.keys.last]
  end

  def fresh_up_data
    date_since = params[:since]
    date_until = params[:until]

    date_range = create_date_range(date_since, date_until)

    fresh_up_data_without_redirect(date_range)
    redirect_to '/facebook'
  end

  def create_date_range(date_since, date_until)
    if(date_since.blank?)
      date_range = ""
    elsif(date_until.blank?)
      date_range = "?since=" + date_since.to_s
    else
      date_range = "?since=" + date_since.to_s + "&until=" + date_until.to_s
    end
    return date_range
  end

  def fresh_up_data_without_redirect(date_range)
    create_client
    @company = current_company
    @page = @company.name.split.join
    page_id = session["fb_page_id"]
    insights = @graph.get_object(page_id + '/insights' + date_range.to_s)
    posts = @graph.get_object(page_id + '/posts' + date_range.to_s)
    FacebookInsights.fresh_up_data(@page, insights)
    FacebookInsights.fresh_up_data(@page.to_s + "_posts", posts)
  end

  def report
    @company = current_company
    @page = @company.name.split.join
    create_client
    get_description_from_params
    get_insights_variables
    get_all_posts
    respond_to do |format|
      format.pdf do
        render  pdf: 'report',
                layout: 'layouts/pdf.html',
                template: 'facebook/index.pdf.erb',
                javascript_delay: 3000,
                encoding: "UTF-8",
                :margin => {:top                => 15,
                            :bottom             => 10,
                            :left               => 20,
                            :right              => 20},
                :footer => {
                  :content => render_to_string(:template => 'layouts/footer.pdf.erb')
                }
      end
    end
  end

  def get_description_from_params
    @description_all_fans = params[:description_all_fans]
    @description_likes_unlikes = params[:description_likes_unlikes]
    @description_page_impressions = params[:description_page_impressions]
    @description_likes_by_source = params[:description_likes_by_source]
    @description_page_posts_impressions = params[:description_page_posts_impressions]
    @description_page_views = params[:description_page_views]
    @description_video_views = params[:description_video_views]
    @description_fans_gender_age = params[:description_fans_gender_age]
    @description_positive_feedback = params[:description_positive_feedback]
    @description_negative_feedback = params[:description_negative_feedback]
    @description_storytellers_gender_age = params[:description_storytellers_gender_age]
    @description_reached_fans_gender_age = params[:description_reached_fans_gender_age]
    @description_complete_video_views = params[:description_complete_video_views]
    @description_external_referrals = params[:description_external_referrals]
    @description_tab_views = params[:description_tab_views]
    @description_fans_information = params[:description_fans_information]
    @description_reached_fans_information = params[:description_reached_fans_information]
    @description_storytellers_information = params[:description_storytellers_information]
    @description_posts = params[:description_posts]
  end

  def login_page
  end

  def login
    # generate a new oauth object with your app data and your callback url
    oauth = Koala::Facebook::OAuth.new(SITE_URL + 'facebook/callback')

    # redirect to facebook to get your code
    redirect_to oauth.url_for_oauth_code
  end

  def logout(message = nil)
    session['fb_access_token'] = nil
    session['fb_page_id'] = nil
    redirect_to '/facebook/login_page' if message.blank?
    redirect_to '/facebook/login_page', notice: message
  end

  # method to handle the redirect from facebook back to you
  def callback
    # get the access token from facebook with your code
    session['fb_access_token'] = Koala::Facebook::OAuth.new(SITE_URL + 'facebook/callback').get_access_token(params[:code])
    redirect_to '/facebook'
  end
end
