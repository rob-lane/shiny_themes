require 'fileutils'
module ThemeTestHelper

  # Create theme directories
  # @param name [String] name of the theme to build directories for
  def build_theme_dir(name)
    FileUtils.mkdir_p(theme_root.join(name, 'views'))
    Rails.application.config.theme.asset_directories.each do |asset_dir_name|
      FileUtils.mkdir_p(theme_root.join(name, 'assets', asset_dir_name, name))
    end
  end

  # Remove root theme directory
  # @param name [String] name of the theme to remove root directory for
  def cleanup_theme_dir(name)
    FileUtils.rmtree(theme_root.join(name)) if Dir.exists?(theme_root.join(name))
  end

  # @return [Pathname] path to the root themes directory
  def theme_root
    @theme_root ||= Rails.root.join(Rails.application.config.theme.path)
  end
end