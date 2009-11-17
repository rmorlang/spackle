require 'optparse'
require 'fileutils'


module Spackle
  class Commandline
    class << self
      def install(mod)
        case mod.to_sym
        when :vim
          src = File.join(File.dirname(__FILE__), "/../../support/vim/spackle.vim")
          dest = File.expand_path "~/.vim/plugin"
          raise "No such directory #{dest} -- cannot install Vim plugin" unless File.directory?(dest)
          FileUtils.copy src, dest
          puts "spackle.vim installed in #{dest}"
        else
          raise "Unrecognized module '#{mod}' -- cannot install"
        end
      end

      def show_error(message)
        puts message
      end

      def parse(options)
        opts = OptionParser.new do |opts|
          opts.banner = "Usage: spackle --install vim\n" +
                        "       spackle [rubyscript] [args_for_script]"

          opts.separator " "
          opts.separator "Options:"

          opts.on("-i", "--install MODULE", "Install a Spackle module.", "Choices: vim") do |mod|
            install(mod)
          end

          opts.on("-h", "--help", "-?", "this help screen") do 
            puts opts
            exit
          end
        end

        if options.empty?
          puts opts
        else
          opts.parse!(options)
        end

        raise "Spackle's wrapper mode is not yet implement" unless options.empty?
      end
    end
  end
end
