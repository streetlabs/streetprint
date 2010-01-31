namespace :cloudfiles do
  desc 'Transfer all photos to cloudfiles.  Keeps track of photos already transfered'
  task :transfer_photos => :environment do
    
    class Paperclip::Attachment
      def valid?
        true
      end
    end
    
    Item.all.each do |i|
      print "Item: #{i.id}"
      
      i.photos.each do |p|
        print "\t\tPhoto: #{p.id}"
        
        cloud_photo = CloudfilePhoto.find_by_photo_id(p.id)
        if(cloud_photo)
          print "\t\tAlready transfered. skipping..."
          
        else
          
          cloud_photo = CloudfilePhoto.new
          
          cloud_photo.item_id             = p.item_id
          cloud_photo.caption             = p.caption
          cloud_photo.order               = p.order
          cloud_photo.photo_id            = p.id
          
          cloud_photo.photo = File.new(p.photo.path)
          
          cloud_photo.save!
          print "\t\tSuccessfully transferred"
          
          # at this point we should maybe set the old photo to nill
          # and possible delete the old photos
        end
        puts
      end
    end
  end
end