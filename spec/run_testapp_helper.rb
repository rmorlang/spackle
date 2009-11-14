module RunTestappHelper
  TEST_APP_DIR = File.join(File.dirname(__FILE__), '../test_app')
  def run_spec(spec_name, options)
    spec_opts = "-r ../lib/spackle --format #{formatter_class_for(options[:with])}" 
    Dir.chdir TEST_APP_DIR
    @output = `spec #{spec_opts} spec/#{spec_name.to_s}_spec.rb 2> /dev/null`
    @status = $?
  end

  def formatter_class_for(formatter)
    case formatter
    when :vim_quickfix
      "Spackle::Spec::Formatter::VimQuickfix"
    else
      raise "unknown formatter #{formatter}"
    end
  end

  def test_output
    @output
  end

  def test_error
    @error
  end

  def status
    @status        
  end

  def exitstatus
    @status.exitstatus
  end
end
