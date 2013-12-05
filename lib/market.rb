require 'btce'

module BotCoin
  class Market

    def inverse price, invert
      invert ? (1.0/price) : price
    end

    def quote action, a, for_b
      if action == :sell || action == :last
        ticker_price action, a, for_b[:for]
      else
        ticker_price action, a, for_b[:with]
      end
    end

    def fee
      0.002
    end

    def minus_fee
      1.0 - fee
    end
    private

    def ticker_price action, a, b
      pair = BotCoin::Pairs.join_symbols a, b
      invert = !BotCoin::Pairs.valid_pair?(pair)
      if invert
        if action == :sell
          action = :buy
        else
          action = :sell
        end
      end
      pair = BotCoin::Pairs.reverse_pair(pair) if invert
      ticker = fetch_ticker pair
      price = ticker[action.to_s].to_f
      inverse price, invert
    end

    def fetch_ticker pair
      ticker = Btce::Ticker.new(pair.to_s)
      ticker.json["ticker"]
    end

  end
end
