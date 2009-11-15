$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'spackle'
require 'spec'
require 'spec/autorun'


require 'run_testapp_helper'
require 'spackle_error_fixture'


Spec::Runner.configure do |config|
  config.include RunTestappHelper
  config.include SpackleErrorFixture
end
