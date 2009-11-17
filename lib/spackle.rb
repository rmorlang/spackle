$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))

require 'spackle/configuration'
require 'spackle/error'
require 'spackle/output'
require 'spackle/spec' if defined? Spec
require 'spackle/helpers/ruby_project_root'

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
      File.unlink(spackle_file) if File.exists?(spackle_file)

      case options[:with]
      when :spec_formatter
        ::Spec::Runner.options.parse_format "Spackle::Spec::SpackleFormatter:/dev/null"
      end
    end

    def load_config
      load_config_from_dotfile 
    end

    def load_config_from_dotfile
      config_files = []
      
      if ENV['SPACKLE_CONFIG']
        # SPACKLE_CONFIG is mostly intended for use with the integration tests
        config_files << File.expand_path(ENV['SPACKLE_CONFIG']) 
      else
        config_files << File.expand_path("~/.spackle") 

        project_root = Spackle::Helpers::RubyProjectRoot.search Dir.pwd
        if project_root
          config_files << File.join(project_root, ".spackle")
        end
      end

      config_files.inject(false) do |config_loaded, file|
        if File.exists? file
          load file 
          config_loaded = true
        end
        config_loaded
      end
    end

    def spackle_file
      projectname = Spackle::Helpers::RubyProjectRoot.search Dir.pwd
      projectname = File.basename(projectname) + ".spackle" if projectname
      filename = configuration.spackle_file || projectname || "default.spackle"

      File.join(tempdir, filename)      
    end

    def tempdir
      configuration.tempdir || '/tmp'
    end

    def test_finished(errors)
      return unless configuration.error_formatter
      File.open( spackle_file, "w", 0600 ) do |f|
        errors.each do |error|
          f.write error_formatter_class.format(error)
        end
      end
      system(configuration.callback_command, spackle_file) if configuration.callback_command
    end

        
  end
end
