require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# This matcher is necessary because the expected/actual strings look just
# like bits of regular Ruby backtraces, which apparently is how autotest
# figures out which files to test. Outputting bits of the backtraces from
# the testapp's test harness mightily confuses an autotest running Spackle.
Spec::Matchers.define :have_spackle do |expected|
  match do |actual|
    actual.spackle_output == expected
  end

  def sanitize(str)
    str.gsub(/_spec.rb/, '_s_p_e_c_dot_r_b')
  end

  failure_message_for_should do |actual|
    <<-EOF
Expected spackles to match, but they didn't! Note that the "expected"
and "got" below have been transformed so autotest doesn't get confused
and blow up. See spec/integration_spec.rb for details.
COMMAND
#{actual.command}
EXPECTED:
#{sanitize expected }
GOT:
#{sanitize actual.spackle_output}
    EOF
  end
end


if ENV['INTEGRATE_SPACKLE']

  # -- expected spackles --------------------------------------------------- 
FAILING_WORKING_CLASS = <<EOF  
./spec/failing_working_class_spec.rb:9: expected false, got true
EOF

ERROR_RAISER = <<EOF
./spec/error_raiser_spec.rb:9: an unhandled error
EOF

MISSING_END = <<EOF
EOF

METHOD_TYPO = <<EOF
./spec/method_typo_spec.rb:9: undefined method `sirt' for [3, 1, 2]:Array
EOF
  # ------------------------------------------------------------------------

  DOT_SPACKLE = '/tmp/dot_spackle'

  describe "integration" do
    before do
      @harness = TestAppHelper::Spec.new
    end


    it "running passing_working_class should return no output" do
      @harness.run(:passing_working_class)
      @harness.spackle_output.should be_empty
    end

    it "running failing_working_class should return a spackle" do
      @harness.run(:failing_working_class)
      @harness.should have_spackle(FAILING_WORKING_CLASS)
    end

    it "running error_raiser should return a spackle" do
      @harness.run(:error_raiser)
      @harness.should have_spackle(ERROR_RAISER)
    end

    it "running missing_end should return a spackle" do
      @harness.run(:missing_end)
      @harness.spackle_output.should be_empty
    end

    it "running method_typo should return a spackle" do
      @harness.run(:method_typo)
      @harness.should have_spackle(METHOD_TYPO)
    end
  end
end
