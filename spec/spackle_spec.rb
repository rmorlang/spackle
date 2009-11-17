require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Spackle::Output::SomeClass
  def self.format(*args)
  end
end


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

    it "should end with default.spackle if no spackle_file specfied in Configuration" do
      Spackle.configuration.spackle_file = nil
      Spackle.spackle_file.should match(%r(/default\.spackle$))
    end

    it "should end with the Configuration's spackle_file if specified" do
      Spackle.configuration.spackle_file = "my_spackle"
      Spackle.spackle_file.should match(%r(/my_spackle$))
    end


  end

  describe "formatter_class" do
    it "should convert the configuration's error_formatter to a class" do
      Spackle.configuration.error_formatter = :some_class
      Spackle.error_formatter_class.should == Spackle::Output::SomeClass
    end

    it "should raise a helpful error if no matching class can be found" do
      Spackle.configuration.error_formatter = :not_existing
      lambda {
        Spackle.error_formatter_class
      }.should raise_error(RuntimeError, /\.spackle/)
    end
  end

  describe "test_finished" do
    before do
      @errors = [ spackle_error_fixture ]
      @formatter = mock("formatter", :format => "string")
      @file = StringIO.new
      File.stub!(:open).and_yield(@file)
      Spackle.stub!(
        :error_formatter_class => @formatter,
        :system => true,
        :spackle_file => @spackle_file
      )
    end

    it "should write the output to the spackle_file" do
      File.should_receive(:open).with(@spackle_file, "w", 0600)
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

  describe "init" do
    before do
      Spackle.stub! :load_config => true,
                    :spackle_file => true,
                    :already_initialized? => false
      File.stub!    :unlink => true
    end
    
    it "should only init once" do
      Spackle.should_receive(:load_config).exactly(1).times
      Spackle.init
      Spackle.stub! :already_initialized? => true
      Spackle.should_not_receive(:load_config)
      Spackle.init
    end

    it "should delete any old file" do
      Spackle.stub! :spackle_file => "file"
      File.should_receive(:unlink).with("file")
      Spackle.init
    end

    it "should load the config" do
      Spackle.should_receive :load_config
      Spackle.init
    end

    it "should insert the RSpec formatter if :with => :spec_formatter specified" do
      Spec::Runner.should_receive(:parse_format).with /Spackle::Spec::Formatter/
      Spackle.init :with => :spec_formatter
    end

  end

end

