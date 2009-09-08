class Item < ActiveRecord::Base
  include ActionController::UrlWriter
  
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
    
    has site_id, created_at, updated_at, published
    set_property :delta => true
  end
  
  

  def to_liquid
    vars = {}
    vars['id'] = id.to_s
    vars['title'] = title.sanitize
    vars['introduction'] = introduction.sanitize if introduction.present?
    vars['year'] = year if year.present?
    vars['month'] = Date::MONTHNAMES[month] if month.present?
    vars['day'] = day if day.present?
    vars['date_details'] = date_details.sanitize if date_details.present?
    vars['location'] = location.sanitize if location.present?
    vars['publisher'] = publisher.sanitize if publisher.present?
    vars['publisher_details'] = publisher_details.sanitize if publisher_details.present?
    vars['seller'] = seller.sanitize if seller.present?
    vars['seller_details'] = seller_details.sanitize if seller_details.present?
    vars['printer'] = printer.sanitize if printer.present?
    vars['printer_details'] = printer_details.sanitize if printer_details.present?
    vars['binder'] = binder.sanitize if binder.present?
    vars['binder_details'] = binder_details.sanitize if binder_details.present?
    vars['price'] = price.sanitize if price.present?
    vars['pagination'] = pagination.sanitize if pagination.present?
    vars['serialized'] = serialized?
    vars['footnotes'] = footnotes.sanitize if footnotes.present?
    vars['endnotes'] = endnotes.sanitize if endnotes.present?
    vars['index'] = index.sanitize if index.present?
    vars['advertisements'] = advertisements.sanitize if advertisements.present?
    vars['item_binding'] = item_binding.sanitize if item_binding.present?
    vars['edges'] = edges.sanitize if edges.present?
    vars['dimensions'] = dimensions.sanitize if dimensions.present?
    vars['foxing'] = foxing?
    vars['illustrations'] = illustrations.sanitize if illustrations.present?
    vars['provenance'] = provenance.sanitize if provenance.present?
    vars['marginalia'] = marginalia.sanitize if marginalia.present?
    vars['summary_of_contents'] = summary_of_contents.sanitize if summary_of_contents.present?
    vars['notes'] = notes.sanitize if notes.present?
    vars['references'] = references.sanitize if references.present?
    vars['reference_number'] = reference_number.sanitize if reference_number.present?
    vars['city'] = city.sanitize if city.present?
    vars['document_type'] = document_type if document_type.present?
    vars['full_text'] = full_text.sanitize if full_text.present?
    vars['google_location'] = google_location if google_location.present?
    vars['date'] = pretty_date if pretty_date.present?
    vars['created_at'] = created_at.strftime("%Y/%m/%d %H:%M") if created_at.present?
    vars['updated_at'] = updated_at.strftime("%Y/%m/%d %H:%M") if updated_at.present?
    
    vars['authors'] = authors if authors.present?
    vars['categories'] = categories if categories.present?
    vars['images'] = photos if photos.present?
    vars['media_files'] = media_files if media_files.present?
    
    vars['first_image'] = photos.first if photos.first.present?
    
    vars['path'] = item_path(self)
    vars['google_location_path'] = item_google_location_path(self)
    vars['full_text_path'] = item_full_text_path(self)
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
