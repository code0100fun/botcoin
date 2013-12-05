module BotCoin
  class Pairs
    class << self
      def reverse_pair pair
        pair.to_s.split('_').reverse.join('_').to_sym
      end

      def join_symbols(*symbols)
        symbols.map(&:to_s).join('_').to_sym
      end

      def pair_for a, b
        pair = join_symbols a, b
        invert = !valid_pair?(pair)
        pair = reverse_pair(pair) if invert
        pair
      end

      def direction_for a, b
        pair = join_symbols a, b
        invert = !valid_pair?(pair)
        invert ? :buy : :sell
      end

      def valid_pair?(pair)
        Btce::API::CURRENCY_PAIRS.include?(pair.to_s)
      end
    end
  end
end
