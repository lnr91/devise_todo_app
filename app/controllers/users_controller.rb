class UsersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :correct_user, except: [:index,:destroy]
  before_filter :admin_user ,only:[:destroy]

  def edit
  end

  def index
    @users = User.all
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to root_path, notice: 'Profile updated'
    else
      render 'edit'
    end
  end

  def destroy
    if User.find(params[:id]).destroy
      redirect_to users_path, notice: 'User deleted'
    end
  end


  private

  def correct_user
    @user = User.find_by_id(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

end