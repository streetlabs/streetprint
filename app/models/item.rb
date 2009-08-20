class Item < ActiveRecord::Base
  has_many :photos, :dependent => :destroy
  has_many :media_files, :dependent => :destroy
  has_many :authored
  has_many :authors, :through => :authored
  has_many :categorizations
  has_many :categories, :through => :categorizations
  belongs_to :site
  belongs_to :author
  belongs_to :document_type
  validates_presence_of :title, :site_id
  validates_numericality_of :year, :allow_nil => true
  before_save :set_date_from_fields
  
  
  define_index do
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
    indexes categories(:name), :as => :categories
    indexes document_type(:name), :as => :document_type
    indexes authors(:name), :as => :authors
    
    has site_id, created_at, updated_at
    set_property :delta => true
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
    logger.info "Sphinx search conditions: " + conditions.inspect
    Item.search(params[:search], :order => sort, :conditions => conditions, :page => params[:page], :per_page => per_page)
  end
  
  def photo_attributes=(photo_attributes)
    photo_attributes.each do |attributes|
      photos.build(attributes)
    end
  end
  
  def photos_list=(photo_list)
    photo_list.delete(-1)
    current_photos = self.photos.map { |p| p.id.to_s }
    to_delete = current_photos - photo_list
    Photo.destroy_pics(self.id, to_delete)
  end

  def media_file_attributes=(media_file_attributes)
    media_file_attributes.each do |attributes|
      unless attributes[:file].blank?
        media_files.build(attributes)
      end
    end
  end
  
  def media_files_list=(media_files_list)
    media_files_list.delete(-1)
    current_media_files = self.media_files.map { |m| m.id.to_s }
    to_delete = current_media_files - media_files_list
    MediaFile.destroy_media_files(self.id, to_delete)
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
  
  private
    def set_date_from_fields
      self.date = Date.new((self.year || 1), (self.month || 1), (self.day || 1))
    end
end
