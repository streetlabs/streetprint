# Load will_paginate gem
require 'will_paginate'
require 'will_paginate/i18n'

# Manually load will_paginate translations since Rails i18n backend
# doesn't automatically reload YAML files added to load_path after initialization
Rails.application.config.after_initialize do
  require 'yaml'

  # Load will_paginate's default translations
  WillPaginate::I18n.load_path.each do |path|
    if File.exist?(path)
      translations = YAML.load_file(path)
      translations.each do |locale, data|
        I18n.backend.store_translations(locale.to_sym, data)
      end
    end
  end

  # Load our custom will_paginate translations
  custom_path = Rails.root.join('config', 'locales', 'will_paginate.en.yml')
  if File.exist?(custom_path)
    translations = YAML.load_file(custom_path)
    translations.each do |locale, data|
      I18n.backend.store_translations(locale.to_sym, data)
    end
  end
end
