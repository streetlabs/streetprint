if RAILS_ENV == "development"
 Paperclip.options[:command_path] = ' /opt/local/bin'
 Paperclip.options[:magick_home] = '/opt/local'
end
