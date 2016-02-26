##Shiny Themes
---  
ShinyThemes is my first rails gem and something I extracted from a blog project.  The gem very simply manages asset 
files and updates the asset pipeline configuration to use those assets.  The idea is all template, stylesheet, 
javascript and image assets are grouped together as a 'theme' which is named by it's root directory.

### Installation  
This gem is a Rails v4 plugin gem

  **Add this to your Gemfile**  
    
    gem 'shiny_themes'
      
  **And install the new gem**
   
    bundle install 
    
Then run the **install generator**

    rails generate shiny_themes:install

This creates a configuration file that points to a theme name and default layout for each environment.  _See 
'config/themes.yml'_

### Theme generation and selection

Themes by default are installed to **'app/themes'** however this path can be updated by changing ```config.theme.path```.
When you create a new theme make sure to restart your application so the asset pipeline picks up the new directory.
Generate a new theme using a rails generator simply called **theme**.

    rails generate shiny_themes:theme name_of_theme --layout=optional_default_layout_name
    
This creates a new default theme with javascript and stylesheet manifests as well as a layout which can be optionally
named something other then **application**.  The theme is installed to the path contained in the config, defaults to 
'app/themes'.

#### Controller specific themes  

You can select a theme specifically for a controller with the class method ```renders_theme``` 

    renders_theme 'theme_name', options = {layout: 'optional_default_layout'}
    
#### Saving theme configuration

You can persist a theme configuration from a specific controller using the ```update_current_theme``` method which 
will update the theme configuration for the controller and by default save the configuration to themes.yml.  

    update_current_theme 'new_theme', options = { layout: 'optional_default_layout', dont_save: false }

### Template Support  
Currently the gem only supports the ERB language for templates.  This should eventually be expanded however the ERB
language is being leveraged by my other projects and was honestly chosen for convenience.  I would like to implement 
HAML and Liquid support eventually.

### Stylesheet Support  
The gem supports two stylesheet languages, traditional CSS and SCSS/SASS.  By default the theme generate command will
produce CSS manifest files that use the ```*=require*``` type asset import.  Provide the generate command with a 
**--sass** option and the manifest will be crated as an scss file using ```@import``` syntax for asset importing.

    rails generate shiny_themes:theme sass_theme --sass
    
##License

This project rocks and uses MIT-LICENSE.