require 'shiny_themes/theme_config'

module ShinyThemes
  # Engine defines configuration and populates from the theme.yml config file.
  # The class also updates the asset pipeline to include theme directories and files
  # as well as including the RendersTheme module in ActionController::Base.
  class Engine < ::Rails::Engine
    # Class methods to help manage the rails config and the associated YAML file.
    class << self
      def theme_config
        @theme_config ||= ShinyThemes::ThemeConfig.new
      end

      def default_options
        { path: File.join('app', 'themes'),
          asset_directories: %w(images stylesheets javascripts) }
      end
    end

    initializer 'shiny_themes.theme_config' do |_|
      Engine.theme_config.load
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
          end
        end
      end
      Dir.glob(Rails.root.join(app.config.theme.path, '*', 'assets', '**', 'manifest*')) do |manifest|
        path = Pathname(manifest)
        next if path.directory?

        if %w(.scss .sass').include?(path.extname)
          app.config.assets.precompile << "#{path.parent.basename}/#{path.basename(".*")}.css"
        else
          app.config.assets.precompile << "#{path.parent.basename}/#{path}"
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