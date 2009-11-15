require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Spackle::Output::SomeClass; end

describe Spackle do
  it "should be configurable" do
    config = Spackle.configuration
    config.should == Spackle.configuration
    Spackle.configure do |c|
      c.should == config
    end
  end

  describe "load_config_from_dotfile" do
    it "should return false if a config file was found" do
      File.stub(:exists?).and_return false
      Spackle.load_config_from_dotfile.should be_false
    end
    it "should return true if a config file was found" do
      File.stub(:exists?).and_return true
      Spackle.stub!(:load)
      Spackle.load_config_from_dotfile.should be_true
    end
  end


  describe "loading configuration" do
    it "should use the vim defaults if no config is found" do
      Spackle.configuration.should_receive(:set_defaults_for).with(:vim)
      Spackle.stub(:load_config_from_dotfile).and_return(false) 
      Spackle.load_config
    end

    it "should not use the vim defaults when a config file is found" do
      Spackle.configuration.should_not_receive(:set_defaults_for).with(:vim)
      Spackle.stub(:load_config_from_dotfile).and_return(true) 
      Spackle.load_config
    end
  end


  describe "tempdir" do
    it "should default to /tmp" do
      Spackle.tempdir.should == "/tmp"
    end

    it "should use the configured tempdir" do
      Spackle.configuration.tempdir = "my_tempdir"
      Spackle.tempdir.should == "my_tempdir"
    end
  end

  describe "spackle_file" do
    it "should return the tempdir" do
      Spackle.stub!(:tempdir).and_return("/temp")
      Spackle.spackle_file.should match(%r{^/temp/.+})
    end
  end

  describe "formatter_class" do
    it "should convert the configuration's error_formatter to a class" do
      Spackle.configuration.error_formatter = :some_class
      Spackle.error_formatter_class.should == Spackle::Output::SomeClass
    end
  end

  describe "test_finished" do
    before do
      @errors = [ spackle_error_fixture ]
      @formatter = mock("formatter", :format => "string")
      @file = StringIO.new
      File.stub!(:open).and_yield(@file)
      Spackle.stub!(
        :formatter_class => @formatter,
        :system => true,
        :spackle_file => @spackle_file
      )
    end

    it "should write the output to the spackle_file" do
      File.should_receive(:open).with(@spackle_file, "w", '0600')
      Spackle.test_finished @errors
    end

    it "should invoke the callback_command if defined" do
      Spackle.configuration.callback_command = '/bin/true'
      Spackle.should_receive(:system).with('/bin/true', @spackle_file)
      Spackle.test_finished @errors
    end

    it "should not invoke the callback_command if none defined" do
      Spackle.configuration.callback_command = nil
      Spackle.should_not_receive(:system)
      Spackle.test_finished @errors
    end

    it "should format the errors" do
      @formatter.should_receive(:format).with(@errors[0])
      Spackle.test_finished @errors
    end

    it "should write formatted output to file" do
      @file.should_receive(:write).with("string")
      Spackle.test_finished @errors
    end
  end

end

