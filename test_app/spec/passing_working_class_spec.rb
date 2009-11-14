require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'working_class'

# this is the one spec we want to be passing

describe WorkingClass do
  it "should return true" do
    WorkingClass.a_method.should be_true
  end
end



