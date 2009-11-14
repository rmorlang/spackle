require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'error_raiser'

# REMEMBER: we want this test to FAIL

describe ErrorRaiser do
  it "should not raise an exception" do
    ErrorRaiser.a_method
  end
end



