require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'working_class'

# REMEMBER: we want this test to FAIL

describe WorkingClass do
  it "should return false" do
    WorkingClass.a_method.should be_false
  end
end



