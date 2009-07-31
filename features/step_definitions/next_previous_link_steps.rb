Then /^there should be a ((next)|(previous)) item link$/ do |link, ignore, ignore|
  assert_have_selector "a##{link}_item_link"
end

Then /^there should not be a ((next)|(previous)) item link$/ do |link, ignore, ignore|
  assert_have_no_selector "a##{link}_item_link"
end