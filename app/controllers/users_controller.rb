class UsersController < ApplicationController
  before_action :load_user, only: :show

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".new.signup_success"
      redirect_to @user
    else
      flash[:danger] = t ".new.signup_fail"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t ".no_exist"
    redirect_to root_path
  end
end
