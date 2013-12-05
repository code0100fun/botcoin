class Arbitrage
  attr_reader :market

  def initialize(account, market)
    @account = account
    @market = market
  end

  def balance
    @account.balance
  end

  def fee
    market.minus_fee
  end

  def price(a, b)
    action = BotCoin::Pairs.direction_for(a,b)
    if action == :sell
      price = market.quote(action, a, :for => b)
    else
      price = market.quote(action, b, :with => a)
    end
    price
  end

  def evaluate(a, b, c)
    a_bal = balance[a]
    a_b = price(a, b)
    b_c = price(b, c)
    c_a = price(c, a)
    multiplier = a_b * fee * b_c * fee * c_a * fee
    profit = (a_bal * multiplier) - a_bal

    {
      a => a_bal,
      b => a_bal * a_b * fee,
      c => a_bal * a_b * fee * b_c * fee,
      BotCoin::Pairs.join_symbols(a,b) => a_b,
      BotCoin::Pairs.join_symbols(b,c) => b_c,
      BotCoin::Pairs.join_symbols(c,a) => c_a,
      :profit => profit,
      :multiplier => multiplier
    }
  end

end


