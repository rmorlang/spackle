require 'spec/runner/formatter/base_formatter'

# This is just a slightly-refactored and cut down version of RSpec's 
# BaseTextFormatter.

module Spackle::Spec
  class BaseFormatter < ::Spec::Runner::Formatter::BaseFormatter
    attr_reader :output, :options
    attr_accessor :errors

    def initialize(options, output)
      # we ignore output, for now
      @options = options
      self.errors = []
    end

    def close      
      Spackle.test_finished errors
    end
  end
end
