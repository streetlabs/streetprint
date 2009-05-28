Then /^the correct sized photos should have been created from the photo$/ do
  id = @photo.id
  dirs = []
  prefix = "#{RAILS_ROOT}/public/system/photos/#{id}/"
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