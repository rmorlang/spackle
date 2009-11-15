module TestAppHelper
  TEST_APP_DIR = File.join(File.dirname(__FILE__), '../test_app')
  class Spec
    attr_reader :status, :test_error, :test_output, :spackle_output
    def initialize(spec_name)
      spec_opts = "-r ../lib/spackle --format Spackle::Spec::SpackleFormatter" 
      Dir.chdir TEST_APP_DIR
      @spackle_output = nil
      @@last_command = "spec #{spec_opts} spec/#{spec_name.to_s}_spec.rb &> /dev/null"
      @test_output = `#{@@last_command}`
      @spackle_output = File.read("/tmp/default.spackle")
      @status = $?
    end

    def exitstatus
      @status.exitstatus
    end

    def self.run(spec_name)
      new(spec_name)
    end

    def self.last_command
      "foo"
    end

    private :initialize
  end

end
