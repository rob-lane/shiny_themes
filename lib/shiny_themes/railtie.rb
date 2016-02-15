require 'rails'
module ShinyThemes
  class Railtie < Rails::Railtie
    # Configuration to support defaults for theme name and layout name
    config.theme = ActiveSupport::OrderedOptions.new
    rake_tasks do
      load "tasks/shiny_themes_tasks.rake"
    end
  end
end