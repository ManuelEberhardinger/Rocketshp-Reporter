class GoogleAnalyticsController < ApplicationController

  # GET /google_analytics
  def index
    session[:show_adwords] = false
    check_since_and_until
    @company = current_company
    check_for_page_id_in_session

    # check if there is a valid token and a id
    if session['google_auth_hash'] && session['google_page_id']
      @face = 'You are logged in! <a href="/google_analytics/logout">Logout</a>'
      get_all_metrics
    # if there is no id redirected to options to choose an id
    elsif session['google_auth_hash']
      redirect_to '/google_analytics/options'
    # redirect to login if token is not valid
    else
      redirect_if_not_logged_in
    end
  # if there is a exception, show error and logout
  rescue => error
    redirect_if_not_logged_in(error.message)
  end

  # GET /google_analytics/adwords
  # same as above only for adwords
  def adwords
    session[:show_adwords] = true
    check_since_and_until
    @company = current_company
    check_for_adwords_id_in_session

    if session['google_auth_hash'] && session['google_adwords_id']
      @face = 'You are logged in! <a href="/google_analytics/logout">Logout</a>'
      get_all_adwords
    elsif session['google_auth_hash']
      redirect_to '/google_analytics/options'
    else
      redirect_if_not_logged_in
    end
  rescue => error
    redirect_if_not_logged_in(error.message)
  end

  # checks if there is already a google id saved
  def check_for_page_id_in_session
    # if the database is empty and there is a param the id will be saved in the db
    if @company.social_id.google_analytics_id.blank? && !params[:page_id].blank?
      @company.social_id.google_analytics_id = "ga:" + params[:page_id].to_s
      session['google_page_id'] = @company.social_id.google_analytics_id
      @company.social_id.save!
    # get id from the db if there is a id saved
    elsif @company.social_id.google_analytics_id
      session['google_page_id'] = @company.social_id.google_analytics_id
    else
      session['google_page_id'] = nil
    end
  end

  # same as check_for_page_id_in_session but for adwords
  def check_for_adwords_id_in_session
    if @company.social_id.google_adwords_id.blank? && !params[:page_id].blank?
      @company.social_id.google_adwords_id = "ga:" + params[:page_id].to_s
      session['google_adwords_id'] = @company.social_id.google_adwords_id
      @company.social_id.save!
    elsif @company.social_id.google_adwords_id
      session['google_adwords_id'] = @company.social_id.google_adwords_id
    else
      session['google_adwords_id'] = nil
    end
  end

  # create google analytics client and authorize with token from omniauth
  def create_client
    @client = Google::Apis::AnalyticsV3::AnalyticsService.new
    @client.authorization = auth_hash['token']
  end

  # GET /google_analytics/options
  def options
    @google_redirect_url = redirect_to_clicked_page
    create_client
    all_profiles = @client.list_account_summaries
    @profiles = []
    all_profiles.items.each { |p|
      @profiles.push(p.to_h)
    }
  rescue => error
    redirect_if_not_logged_in(error.message)
  end

  # set id in database to nil so next time GET options will be shown
  def update_analytics_id
    @company = current_company
    @company.social_id.google_analytics_id = nil
    @company.social_id.save!
    session['google_page_id'] = nil
    redirect_to "/google_analytics"
  end

  # set adwords id to nil so next time will be redirected to options
  def update_adwords_id
    @company = current_company
    @company.social_id.google_adwords_id = nil
    @company.social_id.save!
    session['google_adwords_id'] = nil
    redirect_to "/google_analytics/adwords"
  end

  # redirect to login if not logged in and show message if there is one
  def redirect_if_not_logged_in(message = nil)
    set_google_sessions_to_nil
    if message.blank?
      redirect_to '/google_analytics/login_page'
    else
      redirect_to '/google_analytics/login_page', notice: message
    end
  end

  # reset all google sessions variables
  def set_google_sessions_to_nil
    session['google_auth_hash'] = nil
    session['google_page_id'] = nil
    session['google_since'] = nil
    session['google_until'] = nil
    session['google_adwords_id'] = nil
  end

  # get all metrics with the get_metric_from_api method
  def get_all_metrics
    create_client
    @profile_id = session['google_page_id']

    @page_views = get_metric_from_api('ga:pageviews', 'ga:date')
    @sessions = get_metric_from_api('ga:sessions', 'ga:date')
    @new_returning_visitors = get_metric_from_api('ga:sessions', 'ga:usertype')
    @users = get_metric_from_api('ga:users', 'ga:date')
    @page_views_per_session = get_metric_from_api('ga:pageviewsPerSession', 'ga:date')
    @avg_session_duration = get_metric_from_api('ga:avgSessionDuration', 'ga:date')
    @bounce_rate = get_metric_from_api('ga:bounceRate', 'ga:date')
    @device_category = get_metric_from_api('ga:sessions', 'ga:deviceCategory')
    @percent_new_sessions = get_metric_from_api('ga:percentNewSessions', 'ga:date')
    @mobile_os = get_metric_from_api('ga:sessions', 'ga:operatingsystem', 'gaid::-11')
    @browser_sessions = get_metric_from_api('ga:sessions', 'ga:browser')
    @avg_page_load_time = get_metric_from_api('ga:avgPageLoadTime', 'ga:date')
    @source_medium = get_metric_from_api('ga:sessions', 'ga:sourcemedium', nil, '-ga:sessions')
    @landing_pages = get_metric_from_api('ga:sessions', 'ga:landingpagepath', nil, '-ga:sessions')
    @channel_grouping = get_metric_from_api('ga:sessions', 'ga:channelgrouping')
    @social_networks = get_metric_from_api('ga:sessions', 'ga:socialnetwork')
  end

  # get all metrics for adwords
  def get_all_adwords
    create_client
    @profile_id = session['google_adwords_id']

    @adwords_clicks = get_metric_from_api('ga:adclicks', "ga:campaign,ga:date")
    @prev_adwords_clicks = get_metric_from_api_30_days_ago('ga:adclicks')
    @adwords_campaigns = get_metric_from_api('ga:adclicks,ga:adcost,ga:cpc,ga:ctr', 'ga:campaign')
    @prev_adwords_campaigns = get_metric_from_api_30_days_ago('ga:adclicks,ga:adcost,ga:cpc,ga:ctr', 'ga:campaign')
  end

  # check if there is a date range and set the date range
  def check_since_and_until
    session['google_since'] = Date.strptime(params[:since], '%m/%d/%Y') unless params[:since].blank?
    session['google_until'] = Date.strptime(params[:until], '%m/%d/%Y') unless params[:until].blank?

    if session['google_since'] && session['google_until']
      session['google_since'] = session['google_until'] - 7 if session['google_since'] >= session['google_until']
    end

    # if there is no date range set to a default
    session['google_since'] = Date.today - 38 if session['google_since'].blank?
    session['google_until'] = Date.today - 8 if session['google_until'].blank?
  end

  # method for getting the metrics from the google analytics client with the date in the session
  def get_metric_from_api(_metric, _dimensions = nil, _segment = nil, _sort = nil)
    @client.get_ga_data(@profile_id,
                      Date.parse(session['google_since'].to_s).strftime('%F'),
                      Date.parse(session['google_until'].to_s).strftime('%F'),
                      _metric,
                      dimensions: _dimensions,
                      segment: _segment,
                      sort: _sort)
  end

  # the same as the get_metric_from_api only for 30 days before, so you can compare them
  def get_metric_from_api_30_days_ago(_metric, _dimensions = nil, _segment = nil, _sort = nil)
    @client.get_ga_data(@profile_id,
                      Date.parse(session['google_since'].to_s).days_ago(30).strftime('%F'),
                      Date.parse(session['google_until'].to_s).days_ago(30).strftime('%F'),
                      _metric,
                      dimensions: _dimensions,
                      segment: _segment,
                      sort: _sort)
  end

  # create the the google analytics report
  def report
    get_all_metrics
    get_description_from_params
    create_report('google_analytics/index.pdf.erb')
  end

  # creation of report with template file
  def create_report(template)
    @company = current_company
    check_for_page_id_in_session
    respond_to do |format|
      format.pdf do
        render  pdf: 'report',
                layout: 'layouts/pdf.html',
                template: template,
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

  # create adwords report
  def adwords_report
    get_all_adwords
    get_description_for_adwords
    create_report('google_analytics/adwords.pdf.erb')
  end

  # get descriptions for the report
  # only available when report for adwords is created
  def get_description_for_adwords
    @description_adwords_clicks = params[:description_adwords_clicks]
    @description_adwords_campaigns = params
  end

  # get descriptions for normal analytics report
  # only available when report for analytics is created
  def get_description_from_params
    @description_page_views = params[:description_page_views]
    @description_sessions = params[:description_sessions]
    @description_new_returning_visitors = params[:description_new_returning_visitors]
    @description_users = params[:description_users]
    @description_pages_per_session = params[:description_pages_per_session]
    @description_avg_session_duration = params[:description_avg_session_duration]
    @description_bounce_rate = params[:description_bounce_rate]
    @description_device_category = params[:description_device_category]
    @description_percent_new_sessions = params[:description_percent_new_sessions]
    @description_mobile_os = params[:description_mobile_os]
    @description_browser_sessions = params[:description_browser_sessions]
    @description_avg_page_load_time = params[:description_avg_page_load_time]
    @description_source_medium = params[:description_source_medium]
    @description_landing_pages = params[:description_landing_pages]
    @description_channel_grouping = params[:description_channel_grouping]
    @description_social_networks = params[:description_social_networks]
  end

  # GET /google_analytics/login_page
  def login_page
  end

  # callback for omniauth login
  def callback
    auth_hash
    redirect_to redirect_to_clicked_page
  end

  # redirect to adwords or analytics after login
  # depends from where you get redirected to the login_page
  def redirect_to_clicked_page
    if session[:show_adwords]
      @google_redirect_url = '/google_analytics/adwords'
    else
      @google_redirect_url = '/google_analytics'
    end
  end

  # logout and set sessions to nil
  def logout
    set_google_sessions_to_nil
    redirect_to '/google_analytics/login_page'
  end

  # get the auth_hash from the ominiauth authentication
  def auth_hash
    session['google_auth_hash'] ||= request.env['omniauth.auth'].credentials
  end
end
