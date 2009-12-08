$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))

require 'project_scout'

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
      yield @configuration
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
      File.unlink(spackle_file) if File.exists?(spackle_file)

      case options[:with]
      when :spec_formatter
        ::Spec::Runner.options.parse_format "Spackle::Spec::SpackleFormatter:/dev/null"
      end
    end

    def spackle_file
      projectname = ProjectScout.scan Dir.pwd
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
