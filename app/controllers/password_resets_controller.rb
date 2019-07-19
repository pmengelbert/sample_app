class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      # method doesn't exist yet
      @user.create_reset_digest
      @user.send_reset_email
      flash[:info] = "Check your inbox for instructions on resetting your password."
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end
end
