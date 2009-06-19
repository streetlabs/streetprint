Role.seed(:name) do |r|
  r.name = "admin"
  r.description = "Administrators have all privileges"
end

Role.seed(:name) do |r|
  r.name = "editor"
  r.description = "Editors can only manage the content in the site. They don't have acces to the site configuration."
end

