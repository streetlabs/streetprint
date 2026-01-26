class UserSessionsController < ApplicationController

  access_control do
    allow anonymous, :to => [:new, :create]
    allow logged_in
  end

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(user_session_params.to_h)
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default admin_url
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default root_url
  end

  private

  def user_session_params
    params.require(:user_session).permit(:email, :password, :remember_me)
  end
end
