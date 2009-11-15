require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module Spackle
  describe Error do
    before do
      @subject = Error.new("message")
    end

    it "should store the message" do
      @subject.message.should == "message"
    end

    it "should have an empty backtrace" do
      @subject.backtrace.should be_empty
    end

    it "should allow adding errors by file and line" do
      file = "foo/bar/baz.rb"
      line = 123
      @subject.add_error file, line
      @subject.backtrace.should have(1).errors
      @subject.backtrace.first.file.should == file
      @subject.backtrace.first.line.should == line
    end

    it "should allow adding errors using a block" do
      @subject = Error.new("message") do |e|
        e.add_error "foo/bar", 12
        e.add_error "bubba/flubba", 23
      end
      @subject.backtrace.should have(2).errors
    end
  end
end
