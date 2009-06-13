class Item < ActiveRecord::Base
  has_many :photos, :dependent => :destroy
  has_many :authored
  has_many :authors, :through => :authored
  belongs_to :site
  belongs_to :author
  validates_presence_of :title, :site_id
  validate :valid_date_string
  
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

  define_index do
    indexes title, :sortable => true
    has site_id, created_at, updated_at
    set_property :delta => true
  end
  
  def photo_attributes=(photo_attributes)
    photo_attributes.each do |attributes|
      photos.build(attributes)
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
  
  private
    def valid_date_string
      errors.add(:date, "is invalid. Check format.") if @invalid_date
    end
end
