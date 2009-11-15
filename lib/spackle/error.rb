module Spackle
  class BacktraceEntry
    attr_reader :file, :line
    def initialize(file, line)
      @file, @line = file, line
    end
  end

  class Error
    attr_reader :message, :backtrace

    def initialize(message)
      @message = message
      @backtrace = []
      yield self if block_given?
    end

    def add_error(error_or_file, line = nil)
      case error_or_file
      when Error
        @backtrace << error_or_file
      when String
        @backtrace << BacktraceEntry.new(error_or_file, line)
      else
        raise ArgumentError.new("unrecognized error input '#{error_or_file}'. Should be a filename or a Spackle::BacktraceEntry")
      end
    end

  end
end

