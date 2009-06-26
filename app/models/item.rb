class Item < ActiveRecord::Base
  has_many :photos, :dependent => :destroy
  has_many :authored
  has_many :authors, :through => :authored
  belongs_to :site
  belongs_to :author
  belongs_to :category
  belongs_to :document_type
  validates_presence_of :title, :site_id
  validate :valid_date_string
  
  
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
    indexes category(:name), :as => :category
    indexes document_type(:name), :as => :document_type
    indexes authors(:name), :as => :authors
    
    has site_id, created_at, updated_at, category_id
    set_property :delta => true
  end
  
  
  def self.search_from_params(params)
    sort = params[:sort].gsub(' ', '_') if params[:sort]
    if sort && sort.end_with?('_reverse')
      sort = sort[0..-9] + " DESC"
    elsif sort
      sort = sort.to_sym # b/c 'title' and others need to be passed as symbol
    end
    conditions = {}
    conditions[:site_id] = params[:site_id]
    conditions[:authors] = params[:authors] if params[:authors]
    conditions[:category] = params[:category] if params[:category]
    conditions[:document_type] = params[:document_type] if params[:document_type]
    conditions[:publisher] = params[:publisher] if params[:publisher]
    conditions[:city] = params[:city] if params[:city]
    
    Item.search(params[:search], :order => sort, :conditions => conditions, :page => params[:page], :per_page => 10)
  end
  
  
  def date_string
    date.strftime("%Y/%m/%d") if date
  end
  
  def date_string=(date_string)
    unless date_string.blank?
      raise ArgumentError unless date_string =~ /^(\d\d\d\d)\/(\d{1,2})\/(\d{1,2})$/
    end
    self.date = date_string.blank? ? "" : Date.parse(date_string)
  rescue ArgumentError
    @invalid_date = true
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
  
  private
    def valid_date_string
      errors.add(:date, "is invalid. Check format.") if @invalid_date
    end
end
