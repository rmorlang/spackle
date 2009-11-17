require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'spackle/commandline'
module Spackle
  describe Commandline do
    describe "--install option" do
      before do
        Commandline.stub! :show_error
      end

      it "should call install with the argument" do
        Commandline.should_receive(:install).with("foo")
        result = Commandline.parse(%w(--install foo))
      end

      it "should return 1 and output an error if the argument is unrecognized" do
        lambda {
          Commandline.parse(%w(--install foo)).should == 1
        }.should raise_error(RuntimeError, /unrecognized/i)
      end

      describe "for vim" do
        it "should copy the plugin" do
          Commandline.should_receive(:puts)
          FileUtils.should_receive(:copy).with(/spackle.vim$/, /plugin$/)
          Commandline.parse %w(--install vim)
        end

        it "should raise an error if the destination dir doesn't exist" do
          File.stub! :directory? => false
          lambda {
            Commandline.parse %w(--install vim) 
          }.should raise_error(RuntimeError, /directory/)
        end
      end

      it "should raise an error if it receives unrecognized options" do
        lambda {
          Commandline.parse %w(something unexpected)
        }.should raise_error
      end



    end
  end

end
