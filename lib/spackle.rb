$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))

require 'spackle/configuration'
require 'spackle/error'
require 'spackle/output'
require 'spackle/spec' if defined? Spec

module Spackle
  class << self
    def already_initialized?
      @already_initialized == true
    end

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
      begin
        eval("Spackle::Output::#{class_name}")
      rescue SyntaxError
        raise RuntimeError.new("Spackle Error: no configuration for error_formatter_class -- have you configured Spackle with a .spackle file?")
      rescue NameError
        raise RuntimeError.new("Spackle Error: Cannot find Spackle::Output::#{class_name} -- have you configured Spackle with a .spackle file?")
      end
    end

    def init(options = {})      
      return if already_initialized?

      @already_initialized = true
      load_config
      File.unlink spackle_file

      case options[:with]
      when :spec_formatter
        ::Spec::Runner.parse_format "Spackle::Spec::Formatter:/dev/null"
      end
    end

    def load_config
      load_config_from_dotfile or configuration.set_defaults_for(:vim)
    end

    def load_config_from_dotfile
      config_files = [ File.expand_path("~/.spackle"), "./.spackle"  ]
      # SPACKLE_CONFIG is mostly intended for use with the integration tests
      config_files << File.expand_path(ENV['SPACKLE_CONFIG']) if ENV['SPACKLE_CONFIG']
      config_files.inject(false) do |config_loaded, file|
        if File.exists? file
          load file 
          config_loaded = true
        end
        config_loaded
      end
    end

    def spackle_file
      File.join(tempdir, configuration.spackle_file || "default.spackle")      
    end

    def tempdir
      configuration.tempdir || '/tmp'
    end

    def test_finished(errors)
      File.open( spackle_file, "w", 0600 ) do |f|
        errors.each do |error|
          f.write error_formatter_class.format(error)
        end
      end
      system(configuration.callback_command, spackle_file) if configuration.callback_command
    end

        
  end
end
