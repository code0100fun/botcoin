require 'rspec'
require 'rspec/mocks'
require 'arbitrage'

describe Arbitrage do
  let(:error_delta) { 0.0000000 }
  let(:ltc_btc) { 0.0252 }
  let(:btc_ltc) { 1/ltc_btc }
  let(:btc_usd) { 887 }
  let(:usd_btc) { 1/btc_usd }
  let(:ltc_usd) { 21.0 }
  let(:usd_ltc) { 1/ltc_usd }
  let(:market_service) do
    service = double("market_service")
    service.stub(:exchange).with(:btc_usd).and_return(btc_usd)
    service.stub(:exchange).with(:usd_btc).and_return(usd_btc)
    service.stub(:exchange).with(:ltc_btc).and_return(ltc_btc)
    service.stub(:exchange).with(:btc_ltc).and_return(btc_ltc)
    service.stub(:exchange).with(:ltc_usd).and_return(ltc_usd)
    service.stub(:exchange).with(:usd_ltc).and_return(usd_ltc)
    service
  end

  let(:balance) { { :usd => 100, :ltc => 25, :btc => 0.5 } }

  let(:account_service) do
    service = double("account_service")
    service.stub(:balance).and_return(balance)
    service
  end

  subject(:arbitrage) { Arbitrage.new(account_service, market_service) }

  it 'evaluates an arbitrage from ltc -> btc -> usd -> ltc' do
    result = arbitrage.evaluate(:ltc, :btc, :usd)
    profit = result[:profit]
    ltc = balance[:ltc]
    expected = ((( ltc * ltc_btc) * btc_usd) * usd_ltc) - ltc
    expect(profit).to be_within(error_delta).of(expected)
  end

  it 'evaluates an arbitrage from btc -> usd -> ltc -> btc' do
    result = arbitrage.evaluate(:btc, :usd, :ltc)
    profit = result[:profit]
    btc = balance[:btc]
    expected = ((( btc * btc_usd) * usd_ltc) * ltc_btc ) - btc
    expect(profit).to be_within(error_delta).of(expected)
  end

  it 'evaluates an arbitrage from usd -> ltc -> btc -> usd' do
    result = arbitrage.evaluate(:usd, :ltc, :btc)
    profit = result[:profit]
    usd = balance[:usd]
    expected = ((( usd * usd_ltc) * ltc_btc ) * btc_usd ) - usd
    expect(profit).to be_within(error_delta).of(expected)
  end

  it 'evaluates an arbitrage from usd -> btc -> ltc -> usd' do
    result = arbitrage.evaluate(:usd, :btc, :ltc)
    profit = result[:profit]
    usd = balance[:usd]
    expected = ((( usd * usd_btc) * btc_ltc ) * ltc_usd ) - usd
    expect(profit).to be_within(error_delta).of(expected)
  end

  it 'evaluates an arbitrage from btc -> ltc -> usd -> btc' do
    result = arbitrage.evaluate(:btc, :ltc, :usd)
    profit = result[:profit]
    btc = balance[:btc]
    expected = ((( btc * btc_ltc ) * ltc_usd ) * usd_btc ) - btc
    expect(profit).to be_within(error_delta).of(expected)
  end

  it 'evaluates an arbitrage from ltc -> usd -> btc -> ltc' do
    result = arbitrage.evaluate(:ltc, :usd, :btc)
    profit = result[:profit]
    ltc = balance[:ltc]
    expected = ((( ltc * ltc_usd ) * usd_btc ) * btc_ltc ) - ltc
    expect(profit).to be_within(error_delta).of(expected)
  end

end
