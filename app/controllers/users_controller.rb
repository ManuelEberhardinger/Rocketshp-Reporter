class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :new]

  def edit
    respond_to do |format|
      format.html # edit.html.erb
      format.js # edit.js.erb
    end
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: 'Profile was successfully updated.'
    else
      render 'edit'
    end
  end

  def index
    @users = User.all
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.js # new.js.erb
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(users_path) unless current_user?(@user) || current_user.admin?
    end
end
