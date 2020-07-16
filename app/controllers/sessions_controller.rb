class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password]).present?
      flash[:success] = t ".login_success"
      log_in user
      params[:session][:remember_me] == Settings.checkbox ? remember(user) : forget(user)
      redirect_to user
    else
      flash[:warning] = t ".login_fail"
      redirect_to login_path
    end
  end

  def destroy
    logout if logged_in?
    flash[:success] = t ".logout_success"
    redirect_to login_path
  end
end