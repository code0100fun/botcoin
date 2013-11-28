require 'clockwork'
require_relative '../lib/arbitrage'
require_relative '../lib/market'
require_relative '../lib/account'

module Clockwork
  configure do |config|
    config[:logger] = Logger.new('/dev/null')
  end
end

include Clockwork

account = Account.new
puts account.balance
arbitrage = Arbitrage.new(account,  Market)

tests = [ %i[ltc btc usd], %i[ltc usd btc] ]

def join_symbols(sym_a, sym_b)
  "#{sym_a.to_s}_#{sym_b.to_s}".to_sym
end

every(1.second, 'fetch') do

  tests.each do |test|
    result = arbitrage.evaluate(*test)
    profit = result[:profit]
    a = test[0]
    b = test[1]
    c = test[2]
    a_b = join_symbols(a, b)
    b_c = join_symbols(b, c)
    c_a = join_symbols(c, a)
    puts "#{a.to_s} -(#{result[a_b]})-> #{b.to_s} -(#{result[b_c]})-> #{c.to_s} -(#{result[c_a]})-> #{a.to_s} = #{profit} #{a.to_s} gain"
  end
end
