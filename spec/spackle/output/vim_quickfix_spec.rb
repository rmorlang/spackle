require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Spackle::Output
  describe VimQuickfix do
    before do
      Spackle.stub!(:current_error)
    end
    it "should format errors in 'path:line: message' format" do
      VimQuickfix.new.format_backtrace_line("message", "file", "123").should == "file:123: message"
    end

    it "should strip newlines from messages" do
      VimQuickfix.new.format_backtrace_line("many\nlines", "ignore", "ignore").should_not match(/\n/)
    end

    it "should integrate with Base and return a nice quickfix!" do
      VimQuickfix.format( spackle_error_fixture ).should  == <<-EOF
/clutzy/child/waving/arms:1: CATASTROPHE: the milk was spilled! Begin crying? [Y/n]
/cupboard/shelf/glass:350: CATASTROPHE: the milk was spilled! Begin crying? [Y/n]
/fridge/shelf/jug/milk:4: CATASTROPHE: the milk was spilled! Begin crying? [Y/n]
      EOF
    end
  end
end

