class TimeTrackingsController < ApplicationController
  before_action :set_time_tracking, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:destroy]
  before_action :correct_user, only: [:edit, :update]

  # GET /time_trackings
  def index
    # get all time trackings orderd by date
    @time_trackings = TimeTracking.order(date: :desc)
    companies = Company.all
    user = User.all

    # collect users by name and id so that it can be displayed as a selection
    @companies = companies.collect {|p| [ p['name'], p['id'] ] }
    # add at first an id for 0
    @companies.unshift(['All', 0])

    # the same as company only with users
    @users = user.collect {|p| [ p['name'], p['id'] ] }
    @users.unshift(['All', 0])

    # set date to nil
    @since = @until = nil

    # check if time trackings should be sorted out by company or user
    company_id = params[:company]
    user_id = params[:user]
    @time_trackings = @time_trackings.where(company_id: company_id) unless company_id.blank? || company_id == "0"
    @time_trackings = @time_trackings.where(user_id: user_id) unless user_id.blank? || user_id == "0"

    # check if time trackings should be sorted out by date
    if(!params[:since].blank? && !params[:until].blank?)
      @since = Date.parse(params[:since])
      @until = Date.parse(params[:until])
      @time_trackings = @time_trackings.where("date >= ?", @since).where("date <= ?", @until)
    end
  end

  # GET /time_trackings/1
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.js # show.js.erb
    end
  end

  # GET /time_trackings/1/edit
  def edit
    respond_to do |format|
      format.html # edit.html.erb
      format.js # edit.js.erb
    end
  end

  # PATCH/PUT /time_trackings/1
  def update
    if @time_tracking.update(time_tracking_params)
      redirect_to @time_tracking.company, notice: 'Tracked time was successfully updated.'
    else
      render :edit
    end
  end

  # GET /time_trackings/new
  def new
    @time_tracking = TimeTracking.new

    # set time trackings company and user id because it is not changeable
    # and a hidden field in the form
    @time_tracking.company_id = current_company.id
    @time_tracking.user_id = current_user.id
    respond_to do |format|
      format.html # new.html.erb
      format.js # new.js.erb
    end
  end

  # POST /time_trackings
  def create
    @time_tracking = TimeTracking.new(time_tracking_params)
    if @time_tracking.save
      redirect_to @time_tracking.company, notice: "Time was successfully tracked."
    else
      render :new
    end
  end

  # DELETE /time_trackings/1
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

    # Confirms a correct user
    def correct_user
      set_time_tracking
      @user = User.find(@time_tracking.user.id)
      redirect_to(root_path) unless current_user?(@user) || current_user.admin?
    end
end
