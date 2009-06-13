class Authored < ActiveRecord::Base
  belongs_to :author
  belongs_to :item
  validates_presence_of :author_id
  validates_presence_of :item_id
end
