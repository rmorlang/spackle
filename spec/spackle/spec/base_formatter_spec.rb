require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

module Spackle::Spec
  describe BaseFormatter do
    it "should initialize errors to an empty array" do
      BaseFormatter.new(nil,nil).errors.should == []
    end
    
    it "should notify Spackle of the finished test along with the errors on close" do
      Spackle.should_receive(:test_finished).with([])
      BaseFormatter.new(nil,nil).close
    end
  end
end

