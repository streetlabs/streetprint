class StreetprintSettingsController < ApplicationController

  access_control do
    deny :all
    allow :superadmin
  end
  
  before_filter :get_or_create_settings_object

  def edit
  end
  
  def update
    if @settings.update_attributes(params[:streetprint_settings])
      flash[:notice] = "Successfully updated settings."
      render :action => 'edit'
    else
      render :action => 'edit'
    end
  end
  
  private
    def get_or_create_settings_object
      @settings = StreetprintSettings.first
      # create a settings object if there isn't one
      unless @settings
        @settings = StreetprintSettings.new
        @settings.save!
      end
    end
end
