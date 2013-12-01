require 'rspec'
require 'rspec/mocks'
require 'webmock/rspec'
require 'multi_json'
require 'market'
require 'account'
require 'arbitrage'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
