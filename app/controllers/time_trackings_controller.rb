class TimeTrackingsController < ApplicationController
  before_action :set_time_tracking, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:destroy]
  before_action :correct_user, only: [:edit, :update]

  def index
    @time_trackings = TimeTracking.order(date: :desc)
    companies = Company.all
    user = User.all
    @companies = companies.collect {|p| [ p['name'], p['id'] ] }
    @companies.unshift(['All', 0])
    @users = user.collect {|p| [ p['name'], p['id'] ] }
    @users.unshift(['All', 0])
    @since = @until = nil
    company_id = params[:company]
    user_id = params[:user]
    @time_trackings = @time_trackings.where(company_id: company_id) unless company_id.blank? || company_id == "0"
    @time_trackings = @time_trackings.where(user_id: user_id) unless user_id.blank? || user_id == "0"
    if(!params[:since].blank? && !params[:until].blank?)
      @since = Date.parse(params[:since])
      @until = Date.parse(params[:until])
      @time_trackings = @time_trackings.where("date >= ?", @since).where("date <= ?", @until)
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.js # show.js.erb
    end
  end

  def edit
    respond_to do |format|
      format.html # edit.html.erb
      format.js # edit.js.erb
    end
  end

  def update
    if @time_tracking.update(time_tracking_params)
      redirect_to @time_tracking.company, notice: 'Tracked time was successfully updated.'
    else
      render :edit
    end
  end

  def new
    @time_tracking = TimeTracking.new
    @time_tracking.company_id = current_company.id
    @time_tracking.user_id = current_user.id
    respond_to do |format|
      format.html # new.html.erb
      format.js # new.js.erb
    end
  end

  def create
    @time_tracking = TimeTracking.new(time_tracking_params)
    if @time_tracking.save
      redirect_to @time_tracking.company, notice: "Time was successfully tracked."
    else
      render :new
    end
  end

  def destroy
    id = @time_tracking.company.id.to_s unless @time_tracking.company.nil?
    if @time_tracking.company.nil?
      url = time_trackings_path
    else
      url = '/companies/' + id
    end
    @time_tracking.destroy
    redirect_to url, notice: 'Tracked time was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_tracking
      @time_tracking = TimeTracking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_tracking_params
      params.require(:time_tracking).permit(:company_id, :user_id, :spent_time, :hourly_rate, :date, :description)
    end

    def correct_user
      set_time_tracking
      @user = User.find(@time_tracking.user.id)
      redirect_to(root_path) unless current_user?(@user) || current_user.admin?
    end
end
