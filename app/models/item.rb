class Item < ActiveRecord::Base
  include ActionController::UrlWriter
  
  has_many :photos, :dependent => :destroy
  has_many :media_files, :dependent => :destroy
  has_many :sections, :as => :media
  has_many :authored
  has_many :authors, :through => :authored
  has_many :categorizations
  has_many :categories, :through => :categorizations
  has_many :custom_datas, :as => :data_targetable
  belongs_to :site
  belongs_to :author  
  belongs_to :document_type
  validates_presence_of :title, :site_id
  validates_numericality_of :year, :allow_nil => true
  before_save :set_date_from_fields
  accepts_nested_attributes_for :authors, :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :custom_datas, :allow_destroy => true, :reject_if => proc { |a| a['data'].blank? }
  
  define_index do
    indexes site_id
    indexes title, :sortable => true
    indexes date, :sortable => true
    indexes publisher, :sortable => true
    indexes reference_number, :sortable => true
    indexes location, :sortable => true
    indexes date_details
    indexes dimensions
    indexes pagination
    indexes illustrations
    indexes notes
    indexes city
    indexes full_text
    indexes categories.name, :as => :categories
    indexes authors.name, :as => :authors
    indexes custom_datas.data, :as => :custom_data
    indexes document_type.name, :as => :document_type
    
    has site_id, created_at, updated_at, published
    set_property :delta => true
  end
  
  

  def to_liquid
    vars = {}
    vars['id'] = id.to_s
    vars['title'] = title.sanitize if title.present?
    vars['year'] = year if year.present?
    vars['month'] = Date::MONTHNAMES[month] if month.present?
    vars['day'] = day if day.present?
    vars['date_details'] = date_details.sanitize if date_details.present?
    vars['location'] = location.sanitize if location.present?
    vars['pagination'] = pagination.sanitize if pagination.present?
    vars['dimensions'] = dimensions.sanitize if dimensions.present?
    vars['illustrations'] = illustrations.sanitize if illustrations.present?
    vars['notes'] = notes.sanitize if notes.present?
    vars['reference_number'] = reference_number.sanitize if reference_number.present?
    vars['city'] = city.sanitize if city.present?
    vars['document_type'] = document_type if document_type.present?
    vars['full_text'] = full_text.sanitize if full_text.present?
    vars['google_location'] = google_location if google_location.present?
    vars['date'] = pretty_date if pretty_date.present?
    vars['created_at'] = created_at.strftime("%Y/%m/%d %H:%M") if created_at.present?
    vars['updated_at'] = updated_at.strftime("%Y/%m/%d %H:%M") if updated_at.present?

    vars['publisher'] = publisher if publisher.present?
    vars['authors'] = authors if authors.present?
    vars['custom_datas'] = custom_datas if custom_datas.present?
    vars['categories'] = categories if categories.present?
    vars['images'] = photos if photos.present?
    vars['media_files'] = media_files if media_files.present?

    vars['first_image'] = photos.first if photos.first.present?

    vars['path'] = item_path(self)
    vars['google_location_path'] = item_google_location_path(self)
    vars['full_text_path'] = item_full_text_path(self) if full_text.present?
    vars['full_text'] = full_text if full_text.present?
    vars['full_text_summary'] = full_text.split[0..(50-1)].join(" ") + (full_text.split.size > 50 ? "..." : "") if full_text.present?
    vars['notes_summary'] = notes.split[0..(50-1)].join(" ") + (notes.split.size > 50 ? "..." : "") if notes.present?

    return vars
  end
  
   
  def self.search_from_params(params, site_id, per_page = 10)
    sort = params[:sort].gsub(' ', '_') if params[:sort]
    if sort && sort.end_with?('_reverse')
      sort = sort[0..-9] + " DESC"
    elsif sort
      sort = sort.to_sym # b/c 'title' and others need to be passed as symbol
    end
    sort ||= :created_at
    conditions = {}
    conditions[:site_id] = site_id
    conditions[:authors] = params[:authors] if params[:authors]
    conditions[:categories] = params[:categories] if params[:categories]
    conditions[:document_type] = params[:document_type] if params[:document_type]
    conditions[:publisher] = params[:publisher] if params[:publisher]
    conditions[:city] = params[:city] if params[:city]
    conditions[:published] = true if (params[:published] == true || params[:published] == 'true')
    conditions[:published] = false if (params[:published] == false || params[:published] == 'false')
    logger.info "Sphinx search conditions: " + conditions.inspect
    Item.search(params[:search], :order => sort, :conditions => conditions, :page => params[:page], :max_matches =>1000000, :per_page => per_page, :star => /[\w@.-]+/u)
  end
  
  def self.search_all(params, site_id, per_page = 10)
    @items = []
    sort ||= :created_at
    conditions = {}
    conditions[:site_id] = site_id
    Item.search(params[:search], :order => sort, :conditions => conditions, :page => params[:page], :max_matches =>1000000, :per_page => per_page, :star => /[\w@.-]+/u)
  end
  
  
  def self.random_item(site)
    conditions = {}
    conditions[:site_id] = site.id
    conditions[:published] = true 
    Item.search( :order => "@random ASC", :conditions => conditions, :page => 1, :max_matches =>1, :per_page => 1).first
  end

  def item
    self
  end
  
  def first_image
    photos.first if photos.first.present?
  end
  
  def photo_attributes=(photo_attributes)
    photo_attributes.each do |attributes|
      photos.build(attributes)
    end
  end
  
  def photos_list=(photo_list)
    photo_list.delete(-1)
    current_photos = self.photos.map { |p| p.id.to_s }
    if( self.photos.count > 0 )
      to_delete = current_photos - photo_list
      Photo.destroy_pics(self.id, to_delete)
    end
  end

  def media_file_attributes=(media_file_attributes)
    media_file_attributes.each do |attributes|
      media_files.build(attributes)
    end
  end
  
  def media_files_list=(media_files_list)
    media_files_list.delete '-1' 
    current_media_files = self.media_files.map { |m| m.id.to_s }
    
    if( current_media_files.count > 0 )
      to_delete = current_media_files - media_files_list
      MediaFile.destroy_files(self.id, to_delete) unless to_delete.empty?
    end
  end
  
  def authors_list=(authors_list)
    authors_list = authors_list.map { |a| a.to_i }
    authors_list.delete(-1)
    current_authors = authors.map { |a| a.id }
    to_delete = (current_authors - authors_list).uniq
    to_add = (authors_list - current_authors).uniq
    to_delete.each do |author_id|
      self.authors.delete(Author.find(author_id))
    end
    to_add.each do |author_id|
      self.authors << Author.find(author_id)
    end
  end
  
  def categories_list=(categories_list)
    categories_list = categories_list.map { |a| a.to_i }
    categories_list.delete(-1)
    current_categories = categories.map { |a| a.id }
    to_delete = (current_categories - categories_list).uniq
    to_add = (categories_list - current_categories).uniq
    to_delete.each do |category_id|
      self.categories.delete(Category.find(category_id))
    end
    to_add.each do |category_id|
      self.categories << Category.find(category_id)
    end
  end
  
  def excerpts?
    item.respond_to? "excerpts"
  end
  
  def formatted_title
    item.excerpts? ? item.excerpts.title : item.title
  end
  
  def formatted_location
    item.excerpts? ? item.excerpts.location : item.location
  end
  
  def previous_by_id
    self.class.first(:conditions => ["site_id = ? AND id < ? AND published = TRUE", site_id, id], :order => "id desc")
  end

  def next_by_id
    self.class.first(:conditions => ["site_id = ? AND id > ? AND published = TRUE", site_id, id], :order => "id asc")
  end
  
  def latitude
    unless google_location.blank?
      google_location.split(", ")[0]
    end
  end
  
  def longitude
    unless google_location.blank?
      google_location.split(", ")[1]
    end
  end
  
  def pretty_date
    m = self.month ? Date::MONTHNAMES[self.month] : ''
    [self.year, m, self.day].join(" ").strip
  end
  
  def to_s
    "ITEM: " + self.title
  end
  
  private
    def set_date_from_fields
      self.date = Date.new((self.year || 1), (self.month || 1), (self.day || 1))
    end
end
