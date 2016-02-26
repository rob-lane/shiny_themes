require 'rails/generators'

module ShinyThemes
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      # Create default configuration file in config directory
      def copy_config_file
        copy_file "theme.yml", "config/theme.yml"
      end

      # Create the default themes directory under app
      def create_themes_directory
        empty_directory File.join("app", "themes")
      end
    end
  end
end