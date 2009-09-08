class BrowseArtifactsTemplate < ActiveRecord::Base
  belongs_to :site_theme
  validates_liquid_syntax :template
end
