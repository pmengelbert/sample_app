class UsersController < ApplicationController
  def new
    @user = User.new
    #debugger
  end

  def show
    @user = User.find(params[:id])
    #debugger
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

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
