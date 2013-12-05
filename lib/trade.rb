module BotCoin
  class Trade

    attr_reader :pair, :a, :b, :amount, :action, :price

    def initialize(amount, a, for_b)
      @amount = amount
      @a = a
      @b = for_b.fetch(:for)
      @price = for_b.fetch(:at)
      @market = for_b[:on]
      @pair = Pairs.pair_for(@a, @b)
      @action = Pairs.direction_for(@a, @b)
    end

    def market
      @market ||= Market.new
    end

  end
end
