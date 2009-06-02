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

Factory.define :site do |s|
  s.sequence(:name) { |n| "Mock Site #{n}"}
end

Factory.define :photo do |s|
  s.photo_file_name "mock_photo"
end