require 'btce'

class Market

  def self.exchange pair
    reverse = !self.valid_pair?(pair)
    pair = self.reverse_pair(pair) if reverse
    rate = fetch_rate pair
    reverse ? (1/rate) : rate
  end

  def self.fee
    0.002
  end

  def self.minus_fee
    1.0 - fee
  end

private

  def self.fetch_rate pair
    ticker = Btce::Ticker.new(pair.to_s)
    ticker.json["ticker"]["last"]
  end

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
