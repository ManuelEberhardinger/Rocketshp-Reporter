class LinkedinController < ApplicationController
  def index
    check_since_and_until
    @company = current_company
    check_for_page_id_in_session

    if session['linkedin_auth_hash'] && session['linkedin_page_id']
      create_client
      @face = 'You are logged in! <a href="/linkedin/logout">Logout</a>'
      @id = session['linkedin_page_id']
      get_statistics
    elsif session['linkedin_auth_hash']
      redirect_to '/linkedin/options'
    else
      redirect_if_not_logged_in
    end
  rescue => error
    redirect_if_not_logged_in(error.message)
  end

  def check_since_and_until
    session['linkedin_since'] = (Date.strptime(params[:since], '%m/%d/%Y') + 1.days).to_time.to_i*1000 unless params[:since].blank?
    session['linkedin_until'] = (Date.strptime(params[:until], '%m/%d/%Y') + 1.days).to_time.to_i*1000 unless params[:until].blank?

    if session['linkedin_since'] && session['linkedin_until']
      session['linkedin_since'] = session['linkedin_until'] - (7*24*60*60*1000) if session['linkedin_since'] >= session['linkedin_until']
    end

    session['linkedin_since'] = (Date.today - 32).to_time.to_i*1000 if session['linkedin_since'].blank?
    session['linkedin_until'] = (Date.today - 1).to_time.to_i*1000 if session['linkedin_until'].blank?
  end

  def check_for_page_id_in_session
    if @company.social_id.linkedin_id.blank? && !params[:page_id].blank?
      @company.social_id.linkedin_id = params[:page_id].to_s
      session['linkedin_page_id'] = @company.social_id.linkedin_id
      @company.social_id.save!
    elsif @company.social_id.linkedin_id
      session['linkedin_page_id'] = @company.social_id.linkedin_id
    else
      session['linkedin_page_id'] = nil
    end
  end

  def options
    create_client
    @all_companies = @client.company(is_admin: 'true')
  rescue => error
    redirect_if_not_logged_in(error.message)
  end

  def create_client
    @client = LinkedIn::API.new(auth_hash["token"])
  end

  def get_statistics
    @company_historical_stats = @client.company_historical_status_update_statistics(id: @id,
                          fields: ['time', 'like-count', 'impression-count', 'click-count', 'share-count', 'engagement', 'comment-count'],
                          time_granularity: 'day',
                          start_timestamp: session['linkedin_since'],
                          end_timestamp: session['linkedin_until'])
    @company_follower_stats = @client.company_historical_follow_statistics(id: @id,
                          time_granularity: 'day',
                          start_timestamp: session['linkedin_since'],
                          end_timestamp: session['linkedin_until'])
    @company_updates = @client.company_updates(id: @id)
  end

  def report
    check_since_and_until
    @company = current_company
    @id = session['linkedin_page_id']
    create_client
    get_statistics
    get_description_from_params
    respond_to do |format|
      format.pdf do
        render  pdf: 'report',
                layout: '/layouts/pdf.html',
                template: '/linkedin/index.pdf.erb',
                javascript_delay: 3000,
                encoding: "UTF-8",
                :margin => {:top                => 15,
                            :bottom             => 10,
                            :left               => 20,
                            :right              => 20},
                :footer => {
                  :content => render_to_string(:template => '/layouts/footer.pdf.erb')
                }
      end
    end
  end

  def get_description_from_params
    @description_linkedin_engagements = params[:description_linkedin_engagements]
    @description_linkedin_shares = params[:description_linkedin_shares]
    @description_linkedin_likes = params[:description_linkedin_likes]
    @description_linkedin_comments = params[:description_linkedin_comments]
    @description_linkedin_clicks = params[:description_linkedin_clicks]
    @description_linkedin_posts = params[:description_linkedin_posts]
    @description_linkedin_impressions = params[:description_linkedin_impressions]
    @description_linkedin_followers = params[:description_linkedin_followers]
  end

  def login_page
  end

  def logout
    session['linkedin_auth_hash'] = nil
    redirect_to login_page
  end

  def redirect_if_not_logged_in(message = nil)
    session['linkedin_auth_hash'] = nil
    if message.blank?
      redirect_to '/linkedin/login_page'
    else
      redirect_to '/linkedin/login_page', notice: message
    end
  end

  def callback
    auth_hash
    redirect_to '/linkedin'
  end

  def auth_hash
    session['linkedin_auth_hash'] ||= request.env['omniauth.auth'].credentials
  end
end
