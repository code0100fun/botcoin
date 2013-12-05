require 'spec_helper'

describe BotCoin::Pairs do

  describe '#reverse_pair' do
    it 'makes :usd_ltc into :ltc_usd' do
      expect(BotCoin::Pairs.reverse_pair(:usd_ltc)).to eq(:ltc_usd)
    end
  end

end
