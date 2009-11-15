require 'tempfile'

module TestAppHelper
  TEST_APP_DIR = File.join(File.dirname(__FILE__), '../test_app')
  class Spec
    attr_reader :status, :test_error, :test_output, :spackle_output, :dot_spackle
    attr_accessor :spec_name
    def initialize
      self.spec_name = spec_name
      write_dot_spackle 
      ENV['SPACKLE_CONFIG'] = @dot_spackle.path
    end

    def spackle_output_file
      @spackle_output_file ||= Tempfile.new("spackle")
    end

    def write_dot_spackle
      @dot_spackle = Tempfile.open("spackle")
      @dot_spackle.puts <<-END
        Spackle.configure do |c|
          c.set_defaults_for :vim
          c.spackle_file = "#{File.basename(spackle_output_file.path)}"
          c.tempdir = "#{File.dirname(spackle_output_file.path)}"
        end
      END
      @dot_spackle.close
    end 

    def spec_opts
      "-r ../lib/spackle --format Spackle::Spec::SpackleFormatter" 
    end

    def command
      "spec #{spec_opts} spec/#{spec_name.to_s}_spec.rb"
    end

    def run(spec_name)
      @spec_name = spec_name
      Dir.chdir TEST_APP_DIR
      saved_stderr = STDERR.dup
      STDERR.reopen("/dev/null")
      @test_output = `#{command}`
      STDERR.reopen(saved_stderr)
      @status = $?
      @spackle_output = File.read(spackle_output_file.path)
    end

    def exitstatus
      @status.exitstatus
    end
  end

end
