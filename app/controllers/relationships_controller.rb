class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user_create, only: :create
  before_action :find_user_destroy, only: :destroy

  def create
    
    if @user.blank?
      flash[:danger] = t "user_not_exist"
      redirect_to root_path
    else
      current_user.follow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    end
  end

  def destroy
    if @user.blank?
      flash[:danger] = t "user_not_exist"
      redirect_to root_path
    else
      @user.followed
      current_user.unfollow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    end
  end

  private

  def find_user_create
    @user = User.find_by id: params[:followed_id]
  end

  def find_user_destroy
    @user = Relationship.find_by(id: params[:id])
  end
end
