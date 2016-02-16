module ShinyThemes
  class Engine < ::Rails::Engine
    class << self
      def create_config(default_options = {})
        Rails.application.config.theme = ActiveSupport::OrderedOptions.new
        Rails.application.config.theme.merge!(default_options)
        reload_config
      end

      def reload_config
        if config_pathname.exist?
          Rails.application.config.theme.merge!(YAML.load_file(config_pathname)[Rails.env].symbolize_keys)
        end
      end

      def persist_config
        config_pathname.open('w') do |file|
          file.write(Rails.application.config.theme.to_yaml)
        end
      end

      def config_pathname
        @config_pathname ||= Rails.root.join('config', 'theme.yml')
      end
    end

    initializer 'shiny_themes.theme_config' do |_|
      Engine.create_config(path: File.join('app', 'themes'), asset_directories: %w(images stylesheets javascripts))
    end

    initializer 'shiny_themes.assets_path' do |app|
      Dir.glob(Rails.root.join(app.config.theme.path, '*', 'assets', '**', '*')) do |dir|
        app.config.assets.paths << dir if Pathname(dir).directory?
      end
    end

    initializer 'shiny_themes.precompile_assets' do |app|
      app.config.assets.precompile << Proc.new do |path, filename|
        if path =~ /#{app.config.theme.path}/
          if !%w(.js .css).include?(File.extname(filename))
            true
          elsif path =~ /^[^\/]+\/manifest((_|-).+)?\.(js|css)$/
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