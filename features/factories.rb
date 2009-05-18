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