$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))

require 'spackle/configuration'
require 'spackle/spec' if defined? Spec

module Spackle
  class << self
    def configuration
      @configuration ||= Spackle::Configuration.new
    end

    def configure
      yield configuration
    end    

    def callback_command
      Spackle.configuration.callback_command 
    end


    def load_config
      load_config_from_dotfile or configuration.set_defaults_for(:vim)
    end

    def load_config_from_dotfile
      [ File.expand_path("~/.spackle"), "./.spackle"  ].inject(false) do |config_loaded, file|
        if File.exists? file
          load file 
          config_loaded = true
        end
        config_loaded
      end
    end

    def tempdir
      configuration.tempdir || '/tmp'
    end
        
  end
end
