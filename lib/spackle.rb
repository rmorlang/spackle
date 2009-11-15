$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))

require 'spackle/configuration'
require 'spackle/error'
require 'spackle/output'
require 'spackle/spec' if defined? Spec

module Spackle
  class << self
    def callback_command
      Spackle.configuration.callback_command 
    end

    def configuration
      @configuration ||= Spackle::Configuration.new
    end

    def configure
      yield configuration
    end    

    def error_formatter_class
      class_name = configuration.error_formatter.to_s.
        split("_").collect { |w| w.capitalize }.join
      eval("Spackle::Output::#{class_name}")
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

    def spackle_file
      File.join(tempdir, "default.spackle")      
    end

    def tempdir
      configuration.tempdir || '/tmp'
    end

    def test_finished(errors)
      File.open( spackle_file, "w", "0600" ) do |f|
        errors.each do |error|
          f.write formatter_class.format(error)
        end
      end
      system(configuration.callback_command, spackle_file) if configuration.callback_command
    end

        
  end
end
