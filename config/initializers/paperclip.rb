if (RAILS_ENV == "development") || (RAILS_ENV == "test")
 Paperclip.options[:command_path] = ' /opt/local/bin'
 Paperclip.options[:magick_home] = '/opt/local'
else
  Paperclip.options[:command_path]="/usr/local/bin"
end