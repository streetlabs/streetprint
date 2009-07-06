class Categorization < ActiveRecord::Base
  belongs_to :category
  belongs_to :item
  validates_presence_of :category_id
  validates_presence_of :item_id
end
