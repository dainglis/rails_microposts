class SessionsController < ApplicationController

  def new
  end

  # Generate a new user session
  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      # log in and redirect
      log_in user
      flash[:success] = "Login successful"
      redirect_to user

    else 
      flash.now[:danger] = "Invalid login credentials"
      render 'new'
    end
  end

  # Destroy the current user session
  def destroy
    log_out
    redirect_to root_url
  end
end
