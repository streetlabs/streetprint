class UpdateSitesToNewTheme < ActiveRecord::Migration
  def self.up
    default_theme = 1
    default_hex = 2
    parchment = 3
    Site.all.each do |s|
      theme = case s.style
      when "default"
        1
      when "default_hex"
        2
      when "parchment"
        3
      else
        1
      end
      s.site_theme_id = theme
      s.save!
    end
  end

  def self.down
  end
end
