class User::CustomDatasController < ApplicationController

    before_action :get_site

    access_control do
      allow :owner, :of => :site
      allow :admin, :of => :site
      allow :editor, :of => :site
      allow :superadmin
    end

    def index
      @data_targetable = find_data_targetable
      @custom_datas = data_targetable.custom_datas
    end

    def show
      @custom_data = @site.custom_datas.find(params[:id])

    end

    def new

      @custom_data = @site.custom_datas.new
    end

    def create
      @custom_data = @site.custom_datas.new(custom_data_params)
      @custom_data.site = @site
      if @custom_data.save
        flash[:notice] = "Successfully created Custom Data."
        redirect_to custom_dataadmin_index_path(:subdomain => @site.title)
      else
        render :action => 'new'
      end
    end

    def edit

      @custom_data = @site.custom_datas.find(params[:id])
    end

    def update
      @custom_data = @site.custom_datas.find(params[:id])
      if @custom_data.update(custom_data_params)
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

    private

    def find_data_targetable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end

    def custom_data_params
      params.require(:custom_data).permit(:data, :site_id, :custom_data_type_id, :data_targetable_id, :data_targetable_type)
    end
end
