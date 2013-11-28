require 'rspec'
require 'rspec/mocks'
require 'market'

describe Market do
  describe '#reverse_pair' do
    it 'makes :usd_ltc into :ltc_usd' do
      expect(Market.reverse_pair(:usd_ltc)).to eq(:ltc_usd)
    end
  end
end
