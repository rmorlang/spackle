require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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

end

