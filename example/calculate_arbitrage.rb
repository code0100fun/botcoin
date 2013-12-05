require_relative '../lib/job'

job = BotCoin::Job.new


class FakeAccount
  def balance
    {:usd => 1000, :ltc => 25, :btc => 1}
  end
end
job.execute do

  arbitrage = Arbitrage.new(FakeAccount.new,  BotCoin::Market.new)

  tests = [
    %i[ltc btc usd],
    %i[btc usd ltc],
    %i[usd ltc btc],
    %i[ltc usd btc],
    %i[usd btc ltc],
    %i[btc ltc usd]
  ]

  def f(x)
    "%5.4f" % x
  end

  def round_str amount, symbol
    "#{f(amount)}#{symbol.to_s.upcase}"
  end

  def log(result, a, b, c)
    a_b = BotCoin::Pairs.join_symbols(a, b)
    b_c = BotCoin::Pairs.join_symbols(b, c)
    c_a = BotCoin::Pairs.join_symbols(c, a)
    puts result
    profit = f(result[:profit])

    vals = [round_str(f(result[a]), a),
            round_str(f(result[b]), b),
            round_str(f(result[c]), c)]

    # if profit.to_f > 0
      puts vals.join(" -> ") << " => #{profit} #{a.to_s} gain"
    # else
    #   print "."
    # end

    # puts "#{a.to_s} -(#{f result[a_b]})-> #{b.to_s} -(#{f result[b_c]})-> #{c.to_s} -(#{f result[c_a]})-> #{a.to_s} = #{profit} #{a.to_s} gain"
  end

  every(1.second, 'fetch') do
    tests.each do |test|
      result = arbitrage.evaluate(*test)
      a, b, c = test
      log(result, a,b,c)
    end
  end

end
