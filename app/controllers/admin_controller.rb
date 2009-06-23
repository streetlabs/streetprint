class AdminController < ApplicationController
  before_filter :require_user
end
