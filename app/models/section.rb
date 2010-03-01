class Section < ActiveRecord::Base
  belongs_to :narrative
  belongs_to :site
  belongs_to :media, :polymorphic => true
end
