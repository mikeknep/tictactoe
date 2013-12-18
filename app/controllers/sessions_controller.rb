class SessionsController < ApplicationController
  def new
  end

  def create
    u = User.find_by_username(params[:username])
    if u.present? && u.authenticate(params[:password])
      session[:user_id] = u.id
      redirect_to root_url, notice: 'Sign in successful'
    else
      redirect_to new_session_url, notice: 'Incorrect login info'
    end
  end

  def destroy
    reset_session
    redirect_to new_session_url, notice: 'Sign out successful'
  end

end
