require 'active_model'
require 'shiny_themes/railtie'
require 'shiny_themes/theme'

module ShinyThemes
  # Default directory to install themes in
  DEFAULT_THEME_PATH = File.join('app', 'themes')
  # Asset subdirectories
  THEME_ASSET_DIRECTORIES = %w(images stylesheets javascripts)
end
