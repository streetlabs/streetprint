class Site < ActiveRecord::Base
  has_many :items
  belongs_to :user
  
  validates_presence_of :name, :user_id
  validates_length_of :name, :within => 5..20
  
  def next_item(item)
    current_item_index = items.index(item)
    return current_item_index<items.size-1 ? items[current_item_index+1] : nil
  end
  def previous_item(item)
    current_item_index = items.index(item)
    return current_item_index>0 ? items[current_item_index-1] : nil
  end

end
