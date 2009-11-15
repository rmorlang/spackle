require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module Spackle
  describe Configuration do
    before do
      @subject = Spackle::Configuration.new
    end

    it { should respond_to(:callback_command) }
    it { should respond_to(:callback_command) }
    it { should respond_to(:tempdir) }
    it { should respond_to(:tempdir) }

    it { should respond_to(:set_defaults_for) }

    it "should raise an error if defaults_for receives an unrecognized argument" do
      lambda {
        @subject.set_defaults_for :something_invalid
      }.should raise_error(ArgumentError)
    end

    describe "defaults for vim" do
      before do
        @subject.set_defaults_for :vim
      end

      it "should set the editor to spackle-vim-load-quickfix" do
        @subject.callback_command.should == "spackle-vim-load-quickfix"
      end
    end


  end
end

