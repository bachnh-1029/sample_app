class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user_create, only: :create
  before_action :find_user_destroy, only: :destroy
  before_action :check_user

  def create
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = @user.followed
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def check_user
    return unless @user.blank?

    flash[:danger] = t "user_not_exist"
    redirect_to root_path
  end

  def find_user_create
    @user = User.find_by id: params[:followed_id]
  end

  def find_user_destroy
    @user = Relationship.find_by id: params[:id]
  end
end
