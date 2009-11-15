module Spackle::Output
  class VimQuickfix < Base
    def format_backtrace_line(message, file, line)
      "%s:%d: %s" % [ file, line.to_i, message.gsub(/\n/, ' ') ] 
    end
  end
end
