class UsersController < ApplicationController
  # only call logged_in_user before the edit and update actions
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  
  # only call correct_user before the edit and update actions
  before_action :correct_user, only: [:edit, :update]

  # only allow admins to destroy
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Log them in automatically
      log_in @user

      # Flash a welcome message after successful signup
      flash[:success] = "Welcome, #{@user.name}!"

      # Show them their profile page
      redirect_to user_url(@user)
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Your profile has been updated"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    # Confirms a user is logged in
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in to view this page."
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      # redirect to the root url unless the current user matches the user ID of the view in question
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
