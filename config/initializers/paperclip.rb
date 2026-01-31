# Paperclip configuration
# Command path for ImageMagick
if Rails.env.development?
  Paperclip.options[:command_path] = "/usr/local/bin"
else
  Paperclip.options[:command_path] = "/usr/bin"
end

# Configure asset host for logo URLs
Paperclip.interpolates :asset_host do |attachment, style|
  "https://sp5-public.assets.streetprint.org"
end
