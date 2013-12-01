require 'spec_helper'

describe Market do

  before do
    stub_request(:get, "https://btc-e.com/api/2/btc_usd/ticker").to_return(
      :status => 200, :body =>btc_usd_response
    )
  end

  let(:btc_usd_response) { MultiJson.dump({
      ticker: {
        last: 900,
        buy: 900,
        sell: 901,
      }
    })
  }

  subject(:market){ Market.new }

  describe '#reverse_pair' do
    it 'makes :usd_ltc into :ltc_usd' do
      expect(market.reverse_pair(:usd_ltc)).to eq(:ltc_usd)
    end
  end

  describe 'sell' do

    it 'returns top sell price' do
      price = market.quote :sell, :btc, for: :usd
      expect(price).to eq(901)
    end

    it 'returns top buy price' do
      price = market.quote :buy, :btc, for: :usd
      expect(price).to eq(900)
    end

    it 'returns last price' do
      price = market.quote :last, :btc, for: :usd
      expect(price).to eq(900)
    end

  end
end
