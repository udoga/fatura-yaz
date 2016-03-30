class SessionsController < ApplicationController
  skip_before_filter :require_login
  layout 'login'

  def new
    if session[:user_id] == nil
      render "sessions/new", :layout => false
    else
      redirect_to root_path
    end
  end

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
