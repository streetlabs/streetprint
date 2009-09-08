class NewsPost < ActiveRecord::Base
  validates_presence_of :site_id
  validates_presence_of :title
  validates_presence_of :content
  belongs_to :site
  
  def to_liquid
    args = {}
    args['title'] = self.title.sanitize
    args['content'] = self.content.sanitize
    args['created_at'] = self.created_at.strftime("%d/%m/%y %H:%M")
    return args
  end
end
