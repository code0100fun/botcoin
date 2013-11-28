require 'btce'

class Market

  def self.exchange pair
    reverse = !self.valid_pair?(pair)
    pair = self.reverse_pair(pair) if reverse
    ticker = Btce::Ticker.new(pair.to_s)
    rate = ticker.json["ticker"]["last"]
    reverse ? (1/rate) : rate
  end

private

  def self.currency_pairs
    Btce::API::CURRENCY_PAIRS
  end

  def self.reverse_pair pair
    pair.to_s.split('_').reverse.join('_').to_sym
  end

  def self.valid_pair?(pair)
    self.currency_pairs.include?(pair.to_s)
  end

end