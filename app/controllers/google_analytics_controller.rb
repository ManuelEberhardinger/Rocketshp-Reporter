class GoogleAnalyticsController < ApplicationController
  def index
    if session['google_auth_hash'] && defined? @@drive
      @face = 'You are logged in! <a href="/google_analytics/logout">Logout</a><br>'
      @profile = @@drive.list_account_summaries
      @profile_id = 'ga:' + @profile.items[0].web_properties[0].profiles[0].id
      get_all_metrics
    else
      session['google_auth_hash'] = nil
      redirect_to '/google_analytics/login_page'
    end
  end

  def get_all_metrics
    check_since_and_until
    @since = @@since
    @until = @@until
    @page_views = get_metric_from_api('ga:pageviews', 'ga:date')
    @sessions = get_metric_from_api('ga:sessions', 'ga:date')
    @users = get_metric_from_api('ga:users', 'ga:date')
    @page_views_per_session = get_metric_from_api('ga:pageviewsPerSession', 'ga:date')
  end

  def check_since_and_until
    @@since = Date.today - 31 unless defined? @@since
    @@until = Date.today - 1 unless defined? @@until
  end

  def get_metric_from_api(_metric, _dimensions)
    @@drive.get_ga_data(@profile_id,
                        @@since.strftime('%F'),
                        @@until.strftime('%F'),
                        _metric,
                        dimensions: _dimensions)
  end

  def fresh_up_data
    @@since = Date.strptime(params[:since], '%m/%d/%Y') unless params[:since] == ""
    @@until = Date.strptime(params[:until], '%m/%d/%Y') unless params[:until] == ""
    if @@since >= @@until
      @@since = @@until - 7
    end
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
