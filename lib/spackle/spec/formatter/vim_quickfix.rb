require 'spec/runner/formatter/base_formatter'

# credit to https://wincent.com/blog/running-rspec-specs-from-inside-vim
# for the basis of this formatter

module Spackle
  module Spec
    module Formatter
      class VimQuickfix < ::Spec::Runner::Formatter::BaseFormatter
        attr_reader :output

        def initialize(options, output)
          if String === output
            FileUtils.mkdir_p(File.dirname(output))
            @output = File.open(output, 'w')
          else
            @output = output
          end
        end

        def example_failed(example, counter, failure)
          path = failure.exception.backtrace.find do |frame|
            frame =~ %r{\bspec/.*_spec\.rb:\d+\z}
          end
          message = failure.exception.message.gsub("\n", ' ')
          output.puts "#{relativize_path(path)}: #{message}" if path
        end

        private

        def relativize_path path
          @wd ||= Pathname.new Dir.getwd
          begin
            return Pathname.new(path).relative_path_from(@wd)
          rescue ArgumentError
            # raised unless both paths relative, or both absolute
            return path
          end
        end

        def close
          @output.close  if (IO === @output) & (@output != $stdout)
        end
      end
    end
  end
end
