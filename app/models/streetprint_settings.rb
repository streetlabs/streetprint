class StreetprintSettings < ActiveRecord::Base
  
  # Check the db for use_cloudfiles setting; if false, returns false
  # If the setting is true, returns true only if one of the following conditions are met:
  # * The API key in the db is not blank
  # * The file config/rackspace_cloudfiles.yml exists
  def self.use_cloudfiles?
    instance = self.first
    return false if !instance.use_cloudfiles if instance
    return !instance.cloudfiles_api_key.blank? if instance
    return File.exists? "#{RAILS_ROOT}/config/rackspace_cloudfiles.yml"
  end
  
  # Class method to get cloudfile credentials
  # first tries to get them from the database,
  # if they are not there returns the path to
  # the yml file.
  def self.cloudfiles_credentials
    instance = self.first
    if instance && instance.cloudfiles_api_key
      {
        :api_key => instance.cloudfiles_api_key,
        :username => instance.cloudfiles_username,
        :container => instance.cloudfiles_container
      }
    else
      "#{RAILS_ROOT}/config/rackspace_cloudfiles.yml"
    end
  end
end