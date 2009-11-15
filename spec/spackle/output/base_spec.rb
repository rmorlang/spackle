require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Spackle::Output
  describe Base do
    before do
      @error = spackle_error_fixture
    end

    describe "instance" do
      before do
        @subject = Base.new spackle_error_fixture
      end

      it "should call format_backtrace_line" do
        line_count = spackle_error_fixture.backtrace.size
        @subject.should_receive(:format_backtrace_line).exactly(line_count).times
        @subject.format
      end

      it "should return the formatted output" do
        @subject.stub!(:format_backtrace_line).and_return("foo")
        @subject.format.should == "foo\n" * 3
      end
    end

    describe "instantiating" do
      it "should use Spackle's default error if none specified" do
        Spackle.should_receive(:current_error).and_return(@error)
        Base.new.error.should == @error
      end
    end

    describe "#format class method" do
      before do
        @instance = mock("instance")
      end

      it "should initialize and return formatted lines" do
        Base.should_receive(:new).with(@error).and_return(@instance)
        @instance.should_receive :format
        Base.format @error
      end

      it "should use Spackle's default error if none specified" do
        Base.should_receive(:new).with(@error).and_return(@instance)
        Spackle.should_receive(:current_error).and_return(@error)
        @instance.stub!(:format)
        Base.format
      end
    end
  end
end

