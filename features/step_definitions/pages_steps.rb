Given /^the following pages?$/ do |table|
  table.hashes.each do |hash|
     Factory(:page, hash)
  end
end