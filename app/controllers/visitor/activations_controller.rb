class Visitor::ActivationsController < ApplicationController
  
  access_control do
    allow anonymous
  end
  
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