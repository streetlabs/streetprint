class User::ItemsController < ApplicationController
  before_action :get_site

  access_control do
    allow :owner, :of => :site
    allow :admin, :of => :site
    allow :editor, :of => :site
    allow :superadmin
  end

  def index
    #@items = Item.all_in_page(@site).paginate :page => params[:page], :order => 'created_at DESC'
    if  params[:search]
      @items = Item.search_all(get_search_params(params), @site.id)
    else
      # Rails 4.2: paginate_by_* removed, use where + paginate
      @items = Item.where(:site_id => @site.id).paginate(:page => params[:page], :per_page => 20)
    end

    @count = @site.items.count
    store_location :items_return
  end

  def show
    @item = @site.items.find(params[:id])
    # if a page paramenter exists then we know the item was from that page
    # so we can narrow the search to that page, otherwise we need all the items
    # from the site but will paginate needs a page size so... 1,000,000

    # Rails 4.2: paginate_by_* removed, use where + paginate
    @items = Item.where(:site_id => @site.id).paginate(:page => params[:page], :per_page => 1)

    store_location :items_return
  end

  def new
    @item = @site.items.new
    1.times { @item.photos.build }
    1.times { @item.media_files.build }
  end

  def create
    @item = Item.new(item_params)
    # Can't seem to specify select_month or select_day tags to user item[month] / item[day]
    @item.month = params[:date][:month] if params[:date]
    @item.day = params[:date][:day] if params[:date]
    @item.site = @site
    if @item.save
      flash[:notice] = "Successfully created #{@singular}."
      redirect_to itemadmin_index_url(:subdomain => @site.title)
    else
      render :action => 'new'
    end
  end

  def edit
    @item = @site.items.find(params[:id])
    1.times { @item.photos.build }
    1.times { @item.media_files.build }
  end

  def update
   # params[:photo_ids] ||= []
    @item = Item.find(params[:id])
    @item.assign_attributes(item_params)
    # Can't seem to specify select_month or select_day tags to user item[month] / item[day]
    @item.month = params[:date][:month] if params[:date]
    @item.day = params[:date][:day] if params[:date]

    if @item.save
      flash[:notice] = "Successfully updated #{@singular}."
      redirect_to itemadmin_index_url(:subdomain => @site.title)
    else
      render :action => :edit
    end
  end

  def destroy
    @item = @site.items.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed #{@singular}."
    redirect_to itemadmin_index_url(:subdomain => @site.title)
  end

  private

  def item_params
    params.require(:item).permit(:title, :reference_number, :date, :date_details, :dimensions,
                                  :pagination, :illustrations, :location, :notes, :publisher, :city,
                                  :document_type_id, :full_text, :text_id, :google_location, :year,
                                  :month, :day, :published, :photo_attributes, :photos_list,
                                  :media_file_attributes, :media_files_list,
                                  authors_attributes: [:id, :name, :_destroy],
                                  custom_datas_attributes: [:id, :data, :custom_data_type_id, :_destroy])
  end

end
