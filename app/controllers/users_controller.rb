class UsersController < ApplicationController
  before_action :load_user, only: %i(show edit update)
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(show edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.order_desc.page(params[:page])
                 .per Settings.kaminari.per_page
  end

  def show
    @microposts = @user.microposts.page(params[:page])
                       .per Settings.kaminari.per_page
  end

  def new
    @user = User.new aaaa
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_mail_activate
      flash[:success] = t ".mail_notice"
      redirect_to root_path
    else
      flash[:danger] = t ".new.signup_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".update_success"
      redirect_to @user
    else
      flash[:danger] = t ".update_fail"
      render :edit
    end
  end

  def destroy
    @user = User.find_by id: params[:id]
    if @user.destroy
      flash[:success] = t ".destroy_success"
      redirect_to users_url
    else
      flash[:danger] = t ".destroy_fail"
    end
  end

  private

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end

  def load_user
    @user = User.find_by id: params[:id]
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".log_in_not_yet"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless @user == current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end

confilt
