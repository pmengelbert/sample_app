class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  def hello
    render html: "hello, world!"
  end

  # Confirms a user is logged in
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in to view this page."
      redirect_to login_url
    end
  end

end
