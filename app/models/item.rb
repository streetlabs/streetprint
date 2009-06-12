class Item < ActiveRecord::Base
  has_many :photos, :dependent => :destroy
  belongs_to :site
  validates_presence_of :title, :site_id
  validate :valid_date_string
  
  before_save :convert_date
  
  def date_string
    if(@date_string.nil?)
      return "" if date.nil?
      return date.strftime("%Y/%m/%d")
    else
      @date_string
    end
  end
  
  def date_string=(date_string)
    @date_string = date_string
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
  
  private
    def convert_date
      unless (self.date_string.nil? || self.date_string =="")
        self.date = Date.parse(self.date_string)
      end
    end
    
    def valid_date_string
      return if (self.date_string.nil? || self.date_string =="")
      unless self.date_string =~ /^(\d\d\d\d)\/(\d{1,2})\/(\d{1,2})$/
        errors.add(:date, "must be of the format yyyy/mm/dd")
      end
    end
end
