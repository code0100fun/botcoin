require 'clockwork'
require 'colorize'
require_relative '../lib/arbitrage'
require_relative '../lib/market'
require_relative '../lib/account'
require_relative '../lib/pairs'

module Clockwork
  configure do |config|
    config[:logger] = Logger.new('/dev/null')
  end
end

module BotCoin
  class Job
    include Clockwork

    def account
      @account ||= Account.new
    end

    def execute &block
      instance_eval &block
    end

  end
end
