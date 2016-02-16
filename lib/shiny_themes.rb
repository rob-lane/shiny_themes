require 'active_model'
require 'active_support/concern'
require 'shiny_themes/engine'

module ShinyThemes
  autoload :Theme, 'shiny_themes/theme'
  autoload :RendersTheme, 'shiny_themes/renders_theme'
end
