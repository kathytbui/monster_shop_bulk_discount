class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user_show = User.find(params[:id])
  end
end
