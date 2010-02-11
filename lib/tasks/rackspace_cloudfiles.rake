namespace :cloudfiles do
  desc 'Transfer all photos to cloudfiles.  Keeps track of photos already transfered'
  task :transfer_photos => :environment do
    # Make directory to move deleted photos to
    deleted_dir = "#{RAILS_ROOT}/public/system/deleted_photos/#{RAILS_ENV}"
    Dir.mkdir File.dirname(deleted_dir) unless File.exists? File.dirname(deleted_dir)
    Dir.mkdir deleted_dir unless File.exists? deleted_dir
    
    Item.all.each do |i|
      puts "Item: #{i.id}"
      
      i.photos.each do |p|
        puts "\t\tPhoto: #{p.id}"
        
        if(p.cloudfile_photo)
          puts "\t\t\tAlready has a cloudfile version. skipping..."
        else
          
          cloud_photo = p.build_cloudfile_photo
          cloud_photo.photo = File.new(p.local_photo.photo.path)
          cloud_photo.save!
          
          puts "\t\t\tSuccessfully transferred"
          
          # move old photos
          puts "\t\t\tMoving old photos to /public/deleted_photos"
          photo_dir = "#{File.dirname(File.dirname(p.local_photo.photo.path))}"
          File.rename(photo_dir, "#{deleted_dir}/#{File.basename(photo_dir)}")
          
          puts "\t\t\tDeleting old photo"
          p.local_photo.destroy
          
        end
      end
    end
  end
  
  desc 'Temporary task used to create a local_photo for every photo'
  task :create_local_photos  => :environment do
    Photo.all.each do |photo|
      if CloudfilePhoto.find_by_photo_id(photo.id) == nil && LocalPhoto.find_by_photo_id(photo.id) == nil
        local_photo = LocalPhoto.new
        local_photo.photo_id = photo.id
        local_photo.photo = File.new(photo.photo.path)
        local_photo.save!
        puts "Created local photo #{local_photo.id} for photo #{photo.id}"
      end
    end
  end
end