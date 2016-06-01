class GoogleAnalyticsController < ApplicationController
  def index
    session[:show_adwords] = false
    check_since_and_until
    @company = current_company
    check_for_page_id_in_session

    if session['google_auth_hash'] && session['google_page_id']
      @face = 'You are logged in! <a href="/google_analytics/logout">Logout</a>'
      get_all_metrics
    elsif session['google_auth_hash']
      redirect_to '/google_analytics/options'
    else
      redirect_if_not_logged_in
    end
  rescue => error
    redirect_if_not_logged_in(error.message)
  end

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

  def check_for_page_id_in_session
    if @company.social_id.google_analytics_id.blank? && !params[:page_id].blank?
      @company.social_id.google_analytics_id = "ga:" + params[:page_id].to_s
      session['google_page_id'] = @company.social_id.google_analytics_id
      @company.social_id.save!
    elsif @company.social_id.google_analytics_id
      session['google_page_id'] = @company.social_id.google_analytics_id
    else
      session['google_page_id'] = nil
    end
  end

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

  def create_client
    @client = Google::Apis::AnalyticsV3::AnalyticsService.new
    @client.authorization = auth_hash['token']
  end

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

  def update_analytics_id
    @company = current_company
    @company.social_id.google_analytics_id = nil
    @company.social_id.save!
    redirect_to "/google_analytics"
  end

  def update_adwords_id
    @company = current_company
    @company.social_id.google_adwords_id = nil
    @company.social_id.save!
    redirect_to "/google_analytics/adwords"
  end

  def redirect_if_not_logged_in(message = nil)
    set_google_sessions_to_nil
    if message.blank?
      redirect_to '/google_analytics/login_page'
    else
      redirect_to '/google_analytics/login_page', notice: message
    end
  end

  def set_google_sessions_to_nil
    session['google_auth_hash'] = nil
    session['google_page_id'] = nil
    session['google_since'] = nil
    session['google_until'] = nil
    session['google_adwords_id'] = nil
  end

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

  def get_all_adwords
    create_client
    @profile_id = session['google_page_id']

    @adwords_clicks = get_metric_from_api('ga:adclicks', "ga:campaign,ga:date")
    @prev_adwords_clicks = get_metric_from_api_30_days_ago('ga:adclicks')
    @adwords_campaigns = get_metric_from_api('ga:adclicks,ga:adcost,ga:cpc,ga:ctr', 'ga:campaign')
    @prev_adwords_campaigns = get_metric_from_api_30_days_ago('ga:adclicks,ga:adcost,ga:cpc,ga:ctr', 'ga:campaign')
  end

  def check_since_and_until
    session['google_since'] = Date.strptime(params[:since], '%m/%d/%Y') unless params[:since].blank?
    session['google_until'] = Date.strptime(params[:until], '%m/%d/%Y') unless params[:until].blank?

    if session['google_since'] && session['google_until']
      session['google_since'] = session['google_until'] - 7 if session['google_since'] >= session['google_until']
    end

    session['google_since'] = Date.today - 38 if session['google_since'].blank?
    session['google_until'] = Date.today - 8 if session['google_until'].blank?
  end

  def get_metric_from_api(_metric, _dimensions = nil, _segment = nil, _sort = nil)
    @client.get_ga_data(@profile_id,
                      Date.parse(session['google_since'].to_s).strftime('%F'),
                      Date.parse(session['google_until'].to_s).strftime('%F'),
                      _metric,
                      dimensions: _dimensions,
                      segment: _segment,
                      sort: _sort)
  end

  def get_metric_from_api_30_days_ago(_metric, _dimensions = nil, _segment = nil, _sort = nil)
    @client.get_ga_data(@profile_id,
                      Date.parse(session['google_since'].to_s).days_ago(30).strftime('%F'),
                      Date.parse(session['google_until'].to_s).days_ago(30).strftime('%F'),
                      _metric,
                      dimensions: _dimensions,
                      segment: _segment,
                      sort: _sort)
  end

  def report
    get_all_metrics
    get_description_from_params
    create_report('google_analytics/index.pdf.erb')
  end

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

  def adwords_report
    get_all_adwords
    get_description_for_adwords
    create_report('google_analytics/adwords.pdf.erb')
  end

  def get_description_for_adwords
    @description_adwords_clicks = params[:description_adwords_clicks]
    @description_adwords_campaigns = params
  end

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

  def login_page
  end

  def callback
    auth_hash
    redirect_to redirect_to_clicked_page
  end

  def redirect_to_clicked_page
    if session[:show_adwords]
      @google_redirect_url = '/google_analytics/adwords'
    else
      @google_redirect_url = '/google_analytics'
    end
  end

  def logout
    set_google_sessions_to_nil
    redirect_to '/google_analytics/login_page'
  end

  def auth_hash
    session['google_auth_hash'] ||= request.env['omniauth.auth'].credentials
  end
end
