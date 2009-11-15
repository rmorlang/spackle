require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

module Spackle::Spec
  describe SpackleFormatter do
    before do      
      @output = StringIO.new
      @subject = SpackleFormatter.new({}, @output) 
    end

    describe "example_failed" do
      before do
        @error = mock("error", :add_error => nil)
        Spackle::Error.stub!(:new).and_return @error

        Spackle.stub!(:format_error)

        @exception = mock "exception", {
          :message => "a message",
          :backtrace => [ 
            "some/path/to/file:123",
            "another/path/to/file:345"
          ]
        }
        @failure = mock "failure", { :exception => @exception }
      end

      def example_failed
        @subject.example_failed("example", "counter", @failure)
      end

      it "should create an error with the message" do
        Spackle::Error.should_receive(:new).with("a message").and_return(@error)
        example_failed
      end

      it "should add two entries to the error" do
        @error.should_receive(:add_error).exactly(2).times
        example_failed
      end
      
      it "should add errors by file and line number" do
        @error.should_receive(:add_error) do |file, line|
          correct_args =
            (file == "some/path/to/file" && line = "123") ||
            (file == "another/path/to/file" && line = "345")
          correct_args.should be_true
        end
        example_failed
      end

      it "should format the error object" do
        Spackle.should_receive(:format_error).with(@error)
        example_failed
      end

      it "should append the to the errors format" do
        formatted_error = mock("result")
        Spackle.stub!(:format_error).and_return(formatted_error)
        example_failed
        @subject.errors.last.should == formatted_error
      end
    end
  end
end

