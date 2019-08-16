class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  # Confirms a user is logged in. Redirects to sign up page otherwise.
  def logged_in_user
    unless logged_in?
      store_location
      redirect_to login_url
    end
  end
end
