class NewsPost < ActiveRecord::Base
  validates_presence_of :site_id
  validates_presence_of :title
  validates_presence_of :content
  belongs_to :site
end
