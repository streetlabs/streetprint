class User::MySitesController < ApplicationController
  access_control do
    allow logged_in
  end
end
