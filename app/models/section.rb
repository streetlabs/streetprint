class Section < ActiveRecord::Base
  belongs_to :narrative
  belongs_to :site
  belongs_to :media, :polymorphic => true
  
  def to_liquid
    args = {}
    
    args['content'] = content.sanitize
    args['has_photos'] = media && media.photos
    if media && media.photos && media_index && media.photos[media_index]
      args['main_photo'] = media.photos[media_index]
    elsif media && media.photos && media.photos[0]
      args['main_photo'] = media.photos[0]
    else
      args['main_photo'] = nil
    end
    args['photos'] = media.photos
        
    return args
  end
  
end
