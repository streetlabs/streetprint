class SuperadminController < ApplicationController
  access_control do
    deny :all
    allow :superadmin
  end
end
