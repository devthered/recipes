module SessionsHelper

  # Logs in the provided user.
  def log_in(user)
    session[:user_id] = user.id.to_s
  end

  # Remembers the provided user in a permanent session using cookies.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id.to_s
    cookies.permanent.signed[:remember_token] = user.remember_token
  end

  # Forgets a persistent session by deleting cookies.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget current_user
    session[:user_id] = ''
    @current_user = nil
  end

  # Returns the current user, or nil if not logged in.
  def current_user
    if session[:user_id] and not session[:user_id].empty?
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if !!user && !!user.authenticated?(:remember, cookies.signed[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or_to(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
