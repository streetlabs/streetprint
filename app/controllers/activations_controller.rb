class ActivationsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  
  def new
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @user.active?
  end
 
  def create
    @user = User.find(params[:id])
 
    raise Exception if @user.active?
    @user.activate!
    @user.deliver_activation_confirmation!
    flash[:notice] = "Your account has been activated! Log in to use the site."
    redirect_to root_url
  end
 
end