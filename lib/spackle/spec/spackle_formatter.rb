require 'spackle/spec/base_formatter'

module Spackle::Spec
  class SpackleFormatter < BaseFormatter
    def example_failed(example, counter, failure)
      error = Spackle::Error.new failure.exception.message 
      failure.exception.backtrace.each do |frame|
        file, line = frame.match(/^([^:]+):([0-9]+)/)[1,2]
        error.add_error file, line 
      end
      self.errors << error
    end
  end
end
