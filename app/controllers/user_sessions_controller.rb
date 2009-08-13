class UserSessionsController < ApplicationController
  
  access_control do
    allow anonymous, :to => [:new, :create]
    allow logged_in
  end
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default admin_url
    else
      flash[:error] = "this is something"
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default root_url
  end
end

