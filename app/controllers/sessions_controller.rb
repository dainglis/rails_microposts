class SessionsController < ApplicationController
  before_action :not_logged_in, only: :new

  def new
  end

  # Generate a new user session
  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      # log in and redirect
      log_in user
      params[:session][:remember_me] == '1' ? remember(user)
                                            : forget(user)
      flash[:success] = "Login successful"
      redirected_back_or user

    else 
      flash.now[:danger] = "Invalid login credentials"
      render 'new'
    end
  end

  # Destroy the current user session
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
    # Logged in users cannot fill in the signup
    def not_logged_in
      redirect_to user_path(current_user) if logged_in?
    end
end
