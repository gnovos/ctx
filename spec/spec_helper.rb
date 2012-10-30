$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'rr'
require 'ctx'

RSpec.configure do |config|
  config.mock_with     :rr
  config.color_enabled = true
  config.formatter     = 'documentation'
end
