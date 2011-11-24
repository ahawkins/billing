$: << File.expand_path("../../lib", __FILE__)

require 'simplecov'
SimpleCov.start

require 'billing'

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  config.fail_fast = true
end
