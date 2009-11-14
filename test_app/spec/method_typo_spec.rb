require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'method_typo'

# REMEMBER: we want this test to FAIL

describe MethodTypo do
  it "should not have a typo" do
    MethodTypo.a_method
  end
end



