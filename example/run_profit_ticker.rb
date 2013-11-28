require 'btce'
require 'clockwork'

module Clockwork
  configure do |config|
    # config[:logger] = Logger.new('/dev/null')
  end
end

include Clockwork

class Profit
  def initialize(btc_amt, ltc_amt)
    @ltc_amt = ltc_amt
    @btc_amt = btc_amt
  end

  def update
    ltc_usd = Btce::Ticker.new("ltc_usd")
    btc_usd = Btce::Ticker.new("btc_usd")
    @ltc_usd = ltc_usd.json["ticker"]["last"]
    @btc_usd = btc_usd.json["ticker"]["last"]
  end

  def calculate
    (@ltc_amt * @ltc_usd) - (@btc_amt * @btc_usd)
  end

  def log
    "Profit: #{calculate}"
  end
end

profit = Profit.new(0.4395, 24.95)

every(10.second, 'fetch') do
  profit.update
  puts profit.log
end
