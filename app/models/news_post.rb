class NewsPost < ActiveRecord::Base
  validates_presence_of :site_id
  validates_presence_of :title
  validates_presence_of :content
  belongs_to :site

  def to_liquid
    args = {}
    args['title'] = self.title
    args['content'] = self.content
    args['created_at'] = self.created_at.strftime("%d/%m/%y %H:%M") if self.created_at
    args['id'] = self.id
    return args
  end
end
