When /^I follow "([^\"]*)" within "([^\"]*)"$/ do |link, selector|
  click_link_within selector, link
end


Then /^I should see each of "([^\"]*)"$/ do |elements_csv|
  elements_csv.split(',').each do |element|
    response.should contain(element.strip)
  end
end

Then /^I should not see each of "([^\"]*)"$/ do |elements_csv|
  elements_csv.split.each do |element|
    response.should_not contain(element)
  end
end


Given /^the 'admin' role is missing$/ do
  Role.find_by_name('admin').destroy
end

When /^I fill in "([^\"]*)" with lorem ipsum$/ do |field|
  value = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas porta arcu at diam sodales nec convallis quam porta. Maecenas egestas tempus dolor, sed convallis augue mattis ac. Vestibulum ante tortor, fringilla ut tempor ut, sodales sed metus. Duis ut adipiscing lorem. Maecenas rutrum pretium lacus, nec commodo lorem gravida eget. Suspendisse at augue id magna convallis sollicitudin ac sed arcu. Morbi commodo massa eget orci vulputate scelerisque. Morbi vel purus vestibulum tortor facilisis suscipit ut et lacus. Morbi fermentum quam posuere nisl consectetur molestie. Curabitur vel ante a ante condimentum placerat. Donec bibendum, metus vel cursus dignissim, lectus tortor aliquet lectus, a laoreet leo risus vel neque. Nullam auctor luctus mi non venenatis. Quisque nec eros massa, a imperdiet odio. Sed sit amet nisl at neque ultricies rhoncus. Morbi faucibus lobortis risus, sed facilisis massa suscipit ac. Vestibulum volutpat tempus mattis. Nullam neque leo, pretium sed posuere quis, cursus eget quam. Aenean libero velit, laoreet a adipiscing sit amet, mollis imperdiet nunc. Vivamus eget est vestibulum magna sollicitudin tempus nec semper dolor. Proin at neque nec enim varius facilisis a ac lorem. "
  fill_in(field, :with => value) 
end

Then /^there should be a link to the "([^\"]*)" stylesheet$/ do |stylesheet|
  assert_have_xpath "//link[@rel='stylesheet' and @id='#{stylesheet}']"
end

Then /^the breadcrumb should be empty$/ do
  unless response.body =~ /<div id="breadcrumb">(.*)<\/div>/
    raise "response did not contain breadcrumb"
  end
  raise "Expected breadcrumb to be empty" unless $1 == ''
end

Then /^the breadcrumb should contain "([^\"]*)"$/ do |values|
  unless response.body =~ /<div id="breadcrumb">(.*)<\/div>/
    raise "response did not contain breadcrumb"
  end
  values = values.split(', ')
  values.each do |value|
    unless response.body =~ /#{value}/
      raise "Expected breadcrumb to contain #{value}"
    end
  end
end

Then /^I should be denied access to (.+)$/ do |page_name|
  begin
    visit path_to(page_name)
    raise "Expected to be denied access to #{page_name}"
  rescue Acl9::AccessDenied
    # we want this so just return
  end
end