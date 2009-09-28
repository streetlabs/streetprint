class User::CustomDatasController < ApplicationController
  
    before_filter :get_site
    before_filter :breadcrumb_base_admin

    access_control do
      allow :owner, :of => :site
      allow :admin, :of => :site
      allow :editor, :of => :site
      allow :superadmin
    end

    def index
      add_crumb("Custom Data")
      @data_targetable = find_data_targetable 
      @custom_datas = data_targetable.custom_datas
    end
    
    def show
      @custom_data = @site.custom_datas.find(params[:id])
      
      add_crumb("Custom Data", custom_dataadmin_index_path(:subdomain => @site.title))
      add_crumb @custom_data.name
    end

    def new
      add_crumb("Custom Data", custom_dataadmin_index_path(:subdomain => @site.title))
      add_crumb("New Custom Data")
      
      @custom_data = @site.custom_datas.new
    end

    def create
      @custom_data = @site.custom_datas.new(params[:custom_data])
      @custom_data.site = @site
      if @custom_data.save
        flash[:notice] = "Successfully created Custom Data."
        redirect_to custom_dataadmin_index_path(:subdomain => @site.title)
      else
        render :action => 'new'
      end
    end

    def edit
      add_crumb("Custom Data", custom_dataadmin_index_path(:subdomain => @site.title))
      add_crumb("Edit custom_data")
      
      @custom_data = @site.custom_datas.find(params[:id])
    end

    def update
      @custom_data = @site.custom_datas.find(params[:id])
      if @custom_data.update_attributes(params[:custom_data])
        flash[:notice] = "Successfully updated Custom Data."
        redirect_to custom_dataadmin_index_path(:subdomain => @site.title)
      else
        render :action => 'edit'
      end
    end

    def destroy
      @custom_data = @site.custom_datas.find(params[:id])
      @custom_data.destroy
      flash[:notice] = "Successfully destroyed Custom Data."
      redirect_to custom_dataadmin_index_path(:subdomain => @site.title)
    end
    
    def find_data_targetable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end
end
