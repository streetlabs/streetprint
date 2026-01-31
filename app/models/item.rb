class Item < ActiveRecord::Base
  include Rails.application.routes.url_helpers

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

  # Thinking Sphinx index definition is in app/indices/item_index.rb



  def to_liquid
    vars = {}
    vars['id'] = id.to_s
    vars['title'] = title if title.present?
    vars['year'] = year if year.present?
    vars['month'] = Date::MONTHNAMES[month] if month.present?
    vars['day'] = day if day.present?
    vars['date_details'] = date_details if date_details.present?
    vars['location'] = location.titlecase if location.present?
    vars['pagination'] = pagination if pagination.present?
    vars['dimensions'] = dimensions if dimensions.present?
    vars['illustrations'] = illustrations if illustrations.present?
    vars['notes'] = notes if notes.present?
    vars['reference_number'] = reference_number if reference_number.present?
    vars['city'] = city if city.present?
    vars['document_type'] = document_type if document_type.present?
    vars['full_text'] = full_text if full_text.present?
    vars['google_location'] = google_location if google_location.present?
    vars['date'] = pretty_date if pretty_date.present?
    vars['created_at'] = created_at.strftime("%Y/%m/%d %H:%M") if created_at.present?
    vars['updated_at'] = updated_at.strftime("%Y/%m/%d %H:%M") if updated_at.present?

    vars['publisher'] = publisher if publisher.present?
    vars['authors'] = authors.map(&:to_liquid) if authors.present?
    vars['custom_datas'] = custom_datas.map(&:to_liquid) if custom_datas.present?
    vars['categories'] = categories.map(&:to_liquid) if categories.present?
    vars['images'] = photos.map(&:to_liquid) if photos.present?
    vars['media_files'] = media_files.map(&:to_liquid) if media_files.present?

    vars['first_image'] = photos.first&.to_liquid

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

    # Separate field conditions (for MATCH) from attribute filters (for WHERE)
    field_conditions = {}
    attribute_filters = {}

    # Attributes - use :with for filtering
    attribute_filters[:site_id] = site_id
    attribute_filters[:published] = true if (params[:published] == true || params[:published] == 'true')
    attribute_filters[:published] = false if (params[:published] == false || params[:published] == 'false')

    # Convert document type name to ID if a string is provided
    if params[:document_type]
      if params[:document_type].is_a?(String) && params[:document_type] !~ /^\d+$/
        document_type = DocumentType.find_by(name: params[:document_type], site_id: site_id)
        attribute_filters[:document_type_id] = document_type.id if document_type
      else
        attribute_filters[:document_type_id] = params[:document_type]
      end
    end

    # For author and category filtering, use the multi-value attributes
    # Convert author name to ID if a string is provided
    if params[:authors]
      if params[:authors].is_a?(String)
        author = Author.find_by(name: params[:authors], site_id: site_id)
        attribute_filters[:author_ids] = author.id if author
      else
        attribute_filters[:author_ids] = params[:authors]
      end
    end

    # Convert category name to ID if a string is provided
    if params[:categories]
      if params[:categories].is_a?(String)
        category = Category.find_by(name: params[:categories], site_id: site_id)
        attribute_filters[:category_ids] = category.id if category
      else
        attribute_filters[:category_ids] = params[:categories]
      end
    end

    # Fields - use :conditions for text matching
    field_conditions[:publisher] = params[:publisher] if params[:publisher]
    field_conditions[:city] = params[:city] if params[:city]

    logger.info "Sphinx search - attributes: #{attribute_filters.inspect}, fields: #{field_conditions.inspect}"

    # Use Sphinx/Manticore search with :with for attributes and :conditions for fields
    Item.search(params[:search], :order => sort, :with => attribute_filters, :conditions => field_conditions, :page => params[:page], :max_matches =>1000000, :per_page => per_page, :star => /[\w@.-]+/u)
  end

  def self.search_all(params, site_id, per_page = 10)
    @items = []
    sort ||= :created_at

    # Use :with for attribute filtering (site_id is an attribute, not a field)
    attribute_filters = { :site_id => site_id }

    # Use Sphinx/Manticore search
    logger.info "Using Sphinx search_all with attributes: #{attribute_filters.inspect}"
    Item.search(params[:search], :order => sort, :with => attribute_filters, :page => params[:page], :max_matches =>1000000, :per_page => per_page, :star => /[\w@.-]+/u)
  end


  def self.random_item(site)
    # Use :with for attribute filtering (site_id and published are attributes, not fields)
    attribute_filters = {}
    attribute_filters[:site_id] = site.id
    attribute_filters[:published] = true

    # Use Sphinx/Manticore search for random item
    logger.info "Using Sphinx random_item with attributes: #{attribute_filters.inspect}"
    Item.search(:order => "@random ASC", :with => attribute_filters, :page => 1, :max_matches => 1, :per_page => 1).first
  end

  def item
    self
  end

  def clean_location
    self.location.gsub(/vicinity/, '')
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
    # Rails 4.2: Use new finder syntax
    self.class.where("site_id = ? AND id < ? AND published = TRUE", site_id, id).order("id desc").first
  end

  def next_by_id
    # Rails 4.2: Use new finder syntax
    self.class.where("site_id = ? AND id > ? AND published = TRUE", site_id, id).order("id asc").first
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
