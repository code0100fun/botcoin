require 'spec_helper'

describe Arbitrage do
  before do
    stub_request(:get, "https://btc-e.com/api/2/btc_usd/ticker").to_return(
      :status => 200, :body => btc_usd_response
    )
    stub_request(:get, "https://btc-e.com/api/2/ltc_usd/ticker").to_return(
      :status => 200, :body => ltc_usd_response
    )
    stub_request(:get, "https://btc-e.com/api/2/ltc_btc/ticker").to_return(
      :status => 200, :body => ltc_btc_response
    )
  end

  let(:btc_usd_response) { MultiJson.dump({
      ticker: {
        last: btc_usd,
        buy: btc_usd,
        sell: btc_usd,
      }
    })
  }

  let(:ltc_btc_response) { MultiJson.dump({
      ticker: {
        last: ltc_btc,
        buy: ltc_btc,
        sell: ltc_btc,
      }
    })
  }

  let(:ltc_usd_response) { MultiJson.dump({
      ticker: {
        last: ltc_usd,
        buy: ltc_usd,
        sell: ltc_usd,
      }
    })
  }

  subject(:market){ BotCoin::Market.new }
  let(:error_delta) { 0.0000001 }

  let(:ltc_btc) { 0.0252 }
  let(:btc_ltc) { 1.0/ltc_btc }
  let(:btc_usd) { 887.0 }
  let(:usd_btc) { 1.0/btc_usd }
  let(:ltc_usd) { 21.0 }
  let(:usd_ltc) { 1.0/ltc_usd }
  let(:balance) { { :usd => 100.0, :ltc => 25.0, :btc => 0.5 } }

  let(:account) do
    service = double("account")
    service.stub(:balance).and_return(balance)
    service
  end

  let(:fee) { 1.0 - 0.002 }
  let(:ltc_btc_usd) { ltc_btc * btc_usd * usd_ltc * fee**3 }
  let(:btc_usd_ltc) { btc_usd * usd_ltc * ltc_btc * fee**3 }
  let(:usd_ltc_btc) { usd_ltc * ltc_btc * btc_usd * fee**3 }

  let(:ltc_usd_btc) { ltc_usd * usd_btc * btc_ltc * fee**3 }
  let(:usd_btc_ltc) { usd_btc * btc_ltc * ltc_usd * fee**3 }
  let(:btc_ltc_usd) { btc_ltc * ltc_usd * usd_btc * fee**3 }


  subject(:arbitrage) { Arbitrage.new(account, market) }

  it 'evaluates an arbitrage from ltc -> btc -> usd -> ltc' do
    result = arbitrage.evaluate(:ltc, :btc, :usd)
    profit = result[:profit]
    ltc = balance[:ltc]
    expected = ltc * ltc_btc_usd - ltc
    expect(profit).to be_within(error_delta).of(expected)
  end

  it 'evaluates an arbitrage from btc -> usd -> ltc -> btc' do
    result = arbitrage.evaluate(:btc, :usd, :ltc)
    profit = result[:profit]
    btc = balance[:btc]
    expected = btc * btc_usd_ltc - btc
    expect(profit).to be_within(error_delta).of(expected)
  end

  it 'evaluates an arbitrage from usd -> ltc -> btc -> usd' do
    result = arbitrage.evaluate(:usd, :ltc, :btc)
    profit = result[:profit]
    usd = balance[:usd]
    expected = usd * usd_ltc_btc - usd
    expect(profit).to be_within(error_delta).of(expected)
  end

  it 'evaluates an arbitrage from usd -> btc -> ltc -> usd' do
    result = arbitrage.evaluate(:usd, :btc, :ltc)
    profit = result[:profit]
    usd = balance[:usd]
    expected = usd * usd_btc_ltc - usd
    expect(profit).to be_within(error_delta).of(expected)
  end

  it 'evaluates an arbitrage from btc -> ltc -> usd -> btc' do
    result = arbitrage.evaluate(:btc, :ltc, :usd)
    profit = result[:profit]
    btc = balance[:btc]
    expected = btc * btc_ltc_usd - btc
    expect(profit).to be_within(error_delta).of(expected)
  end

  it 'evaluates an arbitrage from ltc -> usd -> btc -> ltc' do
    result = arbitrage.evaluate(:ltc, :usd, :btc)
    profit = result[:profit]
    ltc = balance[:ltc]
    expected = ltc * ltc_usd_btc - ltc
    expect(profit).to be_within(error_delta).of(expected)
  end

end
