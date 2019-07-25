class PasswordResetsController < ApplicationController
  before_action :valid_user,  only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] 

  def new

  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash[:danger] = "Email address not found."
      redirect_to new_password_reset_path
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      redirect_to edit_password_reset_url(params[:id])
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset successfully."
      redirect_to @user
    else
      redirect_to edit_password_reset_url(params[:id])
    end
  end

  #
  # Helper Methods
  #

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Sets and confirms a valid user.
  def valid_user
    @user = User.find_by(email: params[:email])
    print "\n==========================================\n"
    print !!@user
    print "\n==========================================\n"
    print !!@user.activated?
    print "\n==========================================\n"
    print !!@user.authenticated?(:reset, params[:id])
    print "\n==========================================\n"

    redirect_to root_url unless (!!@user && !!@user.activated? && !!@user.authenticated?(:reset, params[:id]))
  end

  # Checks if password reset link has expired
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset link has expired."
      redirect_to new_password_reset_url
    end
  end
end
