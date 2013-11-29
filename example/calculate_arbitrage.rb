require_relative '../lib/job'

job = BotCoin::Job.new

job.execute do

  arbitrage = Arbitrage.new(account,  Market)

  tests = [
    %i[ltc btc usd],
    %i[ltc usd btc]
  ]

  def join_symbols(*symbols)
    symbols.map(&:to_s).join('_').to_sym
  end

  def f(x)
    "%5.4f" % x
  end

  def log(result, a, b, c)
    a_b = join_symbols(a, b)
    b_c = join_symbols(b, c)
    c_a = join_symbols(c, a)
    profit = f(result[:profit])
    puts "#{a.to_s} -(#{f result[a_b]})-> #{b.to_s} -(#{f result[b_c]})-> #{c.to_s} -(#{f result[c_a]})-> #{a.to_s} = #{profit} #{a.to_s} gain"
  end

  every(1.second, 'fetch') do
    tests.each do |test|
      result = arbitrage.evaluate(*test)
      a, b, c = test
      log(result, a,b,c)
    end
  end

end
