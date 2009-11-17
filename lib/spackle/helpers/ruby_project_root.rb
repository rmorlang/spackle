module Spackle
  module Helpers
    module RubyProjectRoot
      class << self
        # Search recursively from the current working directory up for something
        # that looks like the root directory of a Ruby project.
        #
        # Returns the path to the found project dir, if any. Nil otherwise.
        #
        # Stops looking when it reaches the top of the tree, or the user's
        # home directory.
        #
        # Detects a project dir via any of:
        #  * a config/environment.rb file
        #  * a spec/spec_helper.rb file
        #  * a features/step_definitions directory
        def search(directory)
          directory = File.expand_path(directory)
          while directory != '/'
            return directory if is_project_dir?(directory)
            directory = File.expand_path(directory + '/..')
          end
          nil
        end

        def is_project_dir?(path)
          File.exists?(File.join(path, "config/environment.rb")) ||
            File.exists?(File.join(path, "spec/spec_helper.rb")) ||
            File.directory?(File.join(path, "features/step_definitions"))
        end
      end
    end
  end
end
