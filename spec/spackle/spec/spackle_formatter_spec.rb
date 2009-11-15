require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

module Spackle::Spec
  describe SpackleFormatter do
    it "running passing_working_class should return no output" do
      run_spec(:passing_working_class, :with => :vim_quickfix)
      test_output.should be_empty
    end

    describe "running error_raiser" do
      before(:all) do
        run_spec(:error_rasier, :with => :vim_quickfix)
      end

      it "should return a vim quickfix" do
        test_output.should be_empty
      end
    end


    describe "running missing_end" do
      before(:all) do
        run_spec(:missing_end, :with => :vim_quickfix)
      end

      it "should return a vim quickfix" do
        test_output.should be_empty
      end
    end


    describe "running method_typo" do
      before(:all) do
        run_spec(:method_typo, :with => :vim_quickfix)
      end

      it "should return a vim quickfix" do
        test_output.should match(/^[^:]+:[0-9]+: .+/)
      end
    end


    describe "running failing_working_class" do
      before(:all) do
        run_spec(:failing_working_class, :with => :vim_quickfix)
      end

      it "should return a vim quickfix" do
        test_output.should match(/^[^:]+:[0-9]+: .+/)
      end
    end

  end
end

