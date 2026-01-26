class CustomData < ActiveRecord::Base
  self.table_name = 'custom_datas'

  validates_presence_of :site_id
  belongs_to :data_targetable, :polymorphic => true
  belongs_to :custom_data_type

  def to_liquid
    args = {}
    args['name'] = custom_data_type.name.sanitize
    args['value'] = data.sanitize
    return args
  end

  def item
    data_targetable
  end

end
