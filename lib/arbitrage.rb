class Arbitrage

  def initialize(account, market)
    @account = account
    @market = market
  end

  def balance
    @account.balance
  end

  def market
    @market
  end

  def fee
    market.minus_fee
  end

  def join_symbols(sym_a, sym_b)
    "#{sym_a.to_s}_#{sym_b.to_s}".to_sym
  end

  def exchange_rate(a, b)
    market.exchange(join_symbols(a,b))
  end

  def evaluate(a, b, c)
    a_bal = balance[a]
    a_b = exchange_rate(a, b)
    b_c = exchange_rate(b, c)
    c_a = exchange_rate(c, a)
    multiplier = a_b * fee * b_c * fee * c_a * fee
    profit = (a_bal * multiplier) - a_bal

    {
      join_symbols(a,b) => a_b,
      join_symbols(b,c) => b_c,
      join_symbols(c,a) => c_a,
      :profit => profit,
      :multiplier => multiplier
    }
  end

end


