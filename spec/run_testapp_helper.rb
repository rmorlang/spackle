module RunTestappHelper
  TEST_APP_DIR = File.join(File.dirname(__FILE__), '../test_app')
  attr_reader :status, :test_error, :test_output

  def run_spec(spec_name)
    spec_opts = "-r ../lib/spackle --format Spackle::Spec::SpackleFormatter" 
    Dir.chdir TEST_APP_DIR
    @test_output = `spec #{spec_opts} spec/#{spec_name.to_s}_spec.rb`
    @status = $?
  end

  def exitstatus
    @status.exitstatus
  end
end
