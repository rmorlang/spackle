module Spackle::Output
  # This is the foundation of all Spackle::Output classes, but by itself
  # it does nothing.
  #
  # Using an Output class should be simple:
  # (assuming errors is an Array of Spackle::Error objects)
  # puts Spackle::Output::VimQuickfix.format(errors)
  #
  # The child class (VimQuickfix) only needs to implement the
  # format_backtrace instance method.
  #
  # Spackle::Output::Base is responsible for things like:
  # * iterating over the backtrace collection
  # * making pathnames relative
  # * limiting the number of errors that are output
  # * filtering the backtrace output by filename
  #
  # Spackle::Output::Base interacts with Spackle's Configuration
  #
  # If you're writing your own Output class, it should be quite
  # easy to override some of the Configuration handling if your
  # class requires it.
  #
  class Base
    attr_accessor :error
    def initialize(error = nil)
      self.error = error || Spackle.current_error
    end

    def formatted_lines
      error.backtrace.map do |bt|
        format_backtrace_line error.message, bt.file, bt.line
      end
    end

    def format    
      formatted_lines.join("\n") + "\n"
    end

    def self.format(error = nil)
      new(error || Spackle.current_error).format
    end
  end
end
