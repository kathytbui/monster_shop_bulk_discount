class SessionsController < ApplicationController

  def new
    if session[:user_id].nil?
      render :new
    else
      user = User.find(session[:user_id])
      user_redirect(user)
      flash[:error] = "You are already logged in"
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user != nil && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      user_redirect(user)
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:cart)
    redirect_to "/"
    flash[:success] = "You have successfully logged out"
  end

  private
  def user_redirect(user)
    if user.admin?
      redirect_to "/admin/dashboard"
    elsif user.merchant?
      redirect_to "/merchant/dashboard"
    else
      redirect_to "/profile"
    end
  end
end
