class CustomData < ActiveRecord::Base
  validates_presence_of :site_id
  belongs_to :data_targetable, :polymorphic => true
  belongs_to :custom_data_type
end
