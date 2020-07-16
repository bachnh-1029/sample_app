class MicropostsController < ApplicationController
  before_action :logged_in?, only: %i(create destroy)
  before_action :correct_user, only: :destroy
  before_action :new_micropost, only: :create

  def create
    @micropost.image.attach micropost_params[:image]
    if @micropost.save
      flash[:success] = t "micropost.create_success"
      redirect_to root_url
    else
      flash[:danger] = t "micropost.create_fail"
      @feed_items = feed_items
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost.delete_success"
    else
      flash[:danger] = t "micropost.delete_fail"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOST_PARAMS
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "static_pages.home.not_found_user"
    redirect_to root_url
  end

  def new_micropost
    @micropost = current_user.microposts.build micropost_params
  end

  def feed_items
    current_user.feed.page(params[:page]).per Settings.user.per_page
  end
end
