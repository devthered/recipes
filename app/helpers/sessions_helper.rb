module SessionsHelper

  # Logs in the provided user.
  def log_in(user)
    session[:user_id] = user.id.to_s
  end

  # Logs out the current user.
  def log_out
    session[:user_id] = ''
    @current_user = nil
  end

  # Returns the current user, or nil if not logged in.
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
end
