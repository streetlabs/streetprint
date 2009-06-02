Then /^the correct sized photos should have been created from the photo$/ do
  id = @photo.id
  dirs = []
  prefix = "#{RAILS_ROOT}/public/system/photos/test/#{id}/"
  types = ["large", "original", "thumb"]
  types.each do |type|
    dirs << prefix + type
  end
  
  dirs.each do |dir|
    unless File.exist? dir
      raise "Expected photo to be created in #{dir}"
    end
  end
end

Then /^the photos should not exist$/ do
  @photos.each do |photo|
    if Photo.find_by_id(photo.id)
      raise "Expeced photo with id #{photo.id} to not exist"
    end
  end
end

Then /^the files generated for those photos should not exist$/ do
  prefix = "#{RAILS_ROOT}/public/system/photos/test/"
  @photos.each do |photo|
    dir = prefix + photo.id.to_s
    if File.exists? dir
      raise "Expected file #{dir} to not exist"
    end
  end
end

Then /^the files generated for the photo should not exist$/ do
  prefix = "#{RAILS_ROOT}/public/system/photos/test/"
  path = prefix + @photo.id.to_s
  if File.exists? path
    raise "Expected file #{path} to not exist"
  end
end