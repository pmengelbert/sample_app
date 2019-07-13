module SessionsHelper

  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # remember the user
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user from the session
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
    flash[:success] = "You have successfully logged out."
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by_id(user_id)
    # Assign user_id if cookies.signed... exists
    elsif (user_id = cookies.signed[:user_id])
      # recall the user by id
      user = User.find_by(id: user_id)
      # log  in and set us to the current user in the session
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
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
