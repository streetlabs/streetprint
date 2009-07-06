Factory.define :user  do |f|
  f.sequence(:email) { |n| "user#{n}@example.com" }
  f.password "secret"
  f.password_confirmation { |u| u.password }
end

Factory.define :active_user, :class => User do |f|
  f.sequence(:email) { |n| "active_user#{n}@example.com" }
  f.password "secret"
  f.password_confirmation { |u| u.password }
  f.active true
end

Factory.define :item do |f|
  f.title "ItemTitle"
end

Factory.define :news_post do |f|
  f.title "NewsTitle"
  f.sequence(:content) { |n| "mock news post #{n}" }
end

Factory.define :site do |f|
  f.sequence(:name) { |n| "Mock Site #{n}" }
end

Factory.define :photo do |f|
  f.sequence(:photo_file_name) { |n| "mock_photo_#{n}" }
end

Factory.define :author do |f|
  f.sequence(:name) { |n| "author_#{n}" }
end

Factory.define :authored do |f|
end

Factory.define :categorization do |f|
end

Factory.define :category do |f|
  f.sequence(:name) { |n| "category_#{n}" }
end

Factory.define :document_type do |f|
  f.sequence(:name) { |n| "document_type_#{n}" }
end

Factory.define :membership do |f|
end

Factory.define :role do |f|
  f.sequence(:name) { |n| "role_#{n}" }
end

