module SessionsHelper

  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
    flash[:success] = "Thanks for logging in!"
  end

  # Logs out the current user from the session
  def log_out
    session.delete(:user_id)
    @current_user = nil
    flash[:success] = "You have successfully logged out."
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id])
    end
  end

  def logged_in?
    begin
      current_user.id
    rescue StandardError
      nil
    end
  end
end
