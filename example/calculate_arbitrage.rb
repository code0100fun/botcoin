require_relative '../lib/job'

job = BotCoin::Job.new


class FakeAccount
  def balance
    {:usd => 1000, :ltc => 20, :btc => 1}
  end
end
job.execute do

  arbitrage = Arbitrage.new(FakeAccount.new,  BotCoin::Market.new)

  tests = [
    %i[ltc btc usd],
    # %i[btc usd ltc],
    # %i[usd ltc btc],
    %i[ltc usd btc],
    # %i[usd btc ltc],
    # %i[btc ltc usd]
  ]

  def f(x)
    "%5.4f" % x
  end

  def round_str amount, symbol
    "#{symbol.to_s.upcase}"
  end

  def log(result, a, b, c)
    a_b = BotCoin::Pairs.join_symbols(a, b)
    b_c = BotCoin::Pairs.join_symbols(b, c)
    c_a = BotCoin::Pairs.join_symbols(c, a)
    profit = f(result[:profit])

    vals = [round_str(result[a], a),
            round_str(result[b], b),
            round_str(result[c], c)]

    message =  vals.join(" -> ") << " => #{profit} #{a.to_s} gain"

    if profit.to_f > 0
      puts message.green
    else
      puts message.red
    end

  end

  every(1.second, 'fetch') do
    tests.each do |test|
      result = arbitrage.evaluate(*test)
      a, b, c = test
      log(result, a,b,c)
    end
  end

end
