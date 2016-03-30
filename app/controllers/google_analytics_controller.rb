class GoogleAnalyticsController < ApplicationController
  def index
    if session['google_auth_hash'] && defined? @@drive
      @face = 'You are logged in! <a href="/google_analytics/logout">Logout</a><br>'
      @profile = @@drive.list_account_summaries
      @@profile_id = 'ga:' + @profile.items[0].web_properties[0].profiles[0].id
      get_all_metrics
    else
      redirect_if_not_logged_in
    end
  rescue
    redirect_if_not_logged_in
  end

  def redirect_if_not_logged_in
    @@drive = nil
    session['google_auth_hash'] = nil
    redirect_to '/google_analytics/login_page'
  end

  def get_all_metrics
    check_since_and_until
    @since = @@since
    @until = @@until
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

  def check_since_and_until
    @@since = Date.today - 31 unless defined? @@since
    @@until = Date.today - 1 unless defined? @@until
  end

  def get_metric_from_api(_metric, _dimensions, _segment = nil, _sort = nil)
    @@drive.get_ga_data(@@profile_id,
                        @@since.strftime('%F'),
                        @@until.strftime('%F'),
                        _metric,
                        dimensions: _dimensions,
                        segment: _segment,
                        sort: _sort)
  end

  def report
    get_description_from_params
    get_all_metrics
    respond_to do |format|
      format.pdf do
        render  pdf: 'report',
                layout: 'layouts/pdf.html',
                template: 'google_analytics/index.pdf.erb',
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

  def fresh_up_data
    @@since = Date.strptime(params[:since], '%m/%d/%Y') unless params[:since] == ''
    @@until = Date.strptime(params[:until], '%m/%d/%Y') unless params[:until] == ''
    @@since = @@until - 7 if @@since >= @@until
    redirect_to '/google_analytics'
  end

  def login_page
    @face = '<a href="/auth/google_oauth2">Login</a>'
  end

  def callback
    auth_hash
    @@drive = Google::Apis::AnalyticsV3::AnalyticsService.new
    @@drive.authorization = auth_hash['token']
    redirect_to '/google_analytics'
  end

  def logout
    @@drive = nil
    session['google_auth_hash'] = nil
    redirect_to '/google_analytics'
  end

  def auth_hash
    session['google_auth_hash'] ||= request.env['omniauth.auth'].credentials
  end
end
