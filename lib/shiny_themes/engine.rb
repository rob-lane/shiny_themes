module ShinyThemes
  # Engine defines configuration and populates from the theme.yml config file.
  # The class also updates the asset pipeline to include theme directories and files
  # as well as including the RendersTheme module in ActionController::Base.
  class Engine < ::Rails::Engine
    # Class methods to help manage the rails config and the associated YAML file.
    class << self
      # Create the ordered options, populate with provided hash and load YAML file
      # options.
      # @param default_options [Hash] (Hash.new) - Options to populate the theme
      #   config with.
      # @options default_options [String] :path The path relative to the rails root
      #   where templates are installed
      # @options default_options [Array(String)] :asset_directories Names of
      #   directories containing assets for the theme relative to the 'assets'
      #   directory.
      def create_config(default_options = {})
        Rails.application.config.theme = ActiveSupport::OrderedOptions.new
        Rails.application.config.theme.merge!(default_options)
        reload_config
      end

      # Load the theme.yml file and merge it with the theme configuration
      def reload_config
        if config_pathname.exist?
          Rails.application.config.theme.merge!(YAML.load_file(config_pathname)[Rails.env].symbolize_keys)
        end
      end

      # Save the current state of the theme config to the theme.yml file
      def persist_config
        config_pathname.open('w') do |file|
          file.write(Rails.application.config.theme.to_yaml)
        end
      end

      # The pathname where the theme config file can be found
      def config_pathname
        @config_pathname ||= Rails.root.join('config', 'theme.yml')
      end
    end

    initializer 'shiny_themes.theme_config' do |_|
      Engine.create_config(path: File.join('app', 'themes'), asset_directories: %w(images stylesheets javascripts))
    end

    initializer 'shiny_themes.assets_path' do |app|
      Dir.glob(Rails.root.join(app.config.theme.path, '*', 'assets', '**', '*')) do |dir|
        # Add all themes directories and sub-directories to asset pipeline which
        # makes it necessary to restart the application on theme installation
        app.config.assets.paths << dir if Pathname(dir).directory?
      end
    end

    initializer 'shiny_themes.precompile_assets' do |app|
      app.config.assets.precompile << Proc.new do |path, filename|
        # Precompile if the asset is under the themes directory and is either an
        # image a manifest file or a non css/js asset.
        if path =~ /#{app.config.theme.path}/
          if !%w(.js .css).include?(File.extname(filename))
            true
          elsif path =~ /^[^\/]+\/manifest((_|-).+)?\.(js|css)$/ # named or starts with manifest
            true
          else
            false
          end
        end
      end
    end

    initializer 'shiny_themes.application_controller' do |_|
      ActiveSupport.on_load :action_controller do
        ActionController::Base.class_eval do
          include RendersTheme
        end
      end
    end
  end
end