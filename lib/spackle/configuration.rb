module Spackle
  class Configuration
    # The command to invoke when Spackle finds errors. It will receive
    # a single argument, being the path to the Spackle errors file.
    # If left unspecified, no command is invoked.
    attr_accessor :callback_command

    # Where to store the Spackle error files. If unspecified, Spackle will
    # default to /tmp
    attr_accessor :tempdir

    # Configure Spackle with defaults. Currently only accepts :vim as an
    # argument, which configures spackle to use spackle-vim-load-quickfix
    # as a callback command
    def set_defaults_for(mode)
      case mode.to_sym
      when :vim
        self.callback_command = "spackle-vim-load-quickfix"
      else
        raise ArgumentError.new("unknown Spackle mode: '#{mode}'")
      end
    end


  end
end
