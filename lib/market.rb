require 'btce'

class Market

  def inverse price, invert
    invert ? (1.0/price) : price
  end

  def exchange a, b
    ticker_price :last, a, b
  end

  def sell a, b
    ticker_price :sell, a, b
  end

  def buy a, b
    ticker_price :buy, a, b
  end

  def quote action, a, for_b
    ticker_price action, a, for_b[:for]
  end

  def fee
    0.002
  end

  def minus_fee
    1.0 - fee
  end

  def reverse_pair pair
    pair.to_s.split('_').reverse.join('_').to_sym
  end

  def join_symbols(*symbols)
    symbols.map(&:to_s).join('_').to_sym
  end

private

  def ticker_price action, a, b
    pair = join_symbols a, b
    invert = !valid_pair?(pair)
    pair = reverse_pair(pair) if invert
    ticker = fetch_ticker pair
    price = ticker[action.to_s].to_f
    inverse price, invert
  end

  def fetch_ticker pair
    ticker = Btce::Ticker.new(pair.to_s)
    ticker.json["ticker"]
  end

  def valid_pair?(pair)
    Btce::API::CURRENCY_PAIRS.include?(pair.to_s)
  end

end
