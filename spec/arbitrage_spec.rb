require 'spec_helper'

describe Arbitrage do
  let(:error_delta) { 0.0000001 }

  let(:ltc_btc) { 0.0252 }
  let(:btc_ltc) { 1.0/ltc_btc }
  let(:btc_usd) { 887.0 }
  let(:usd_btc) { 1.0/btc_usd }
  let(:ltc_usd) { 21.0 }
  let(:usd_ltc) { 1.0/ltc_usd }

  let(:market) do
    service = double("market")
    service.stub(:quote).with(:sell, :btc, for: :usd).and_return(btc_usd)
    service.stub(:quote).with(:sell, :usd, for: :btc).and_return(usd_btc)
    service.stub(:quote).with(:sell, :ltc, for: :btc).and_return(ltc_btc)
    service.stub(:quote).with(:sell, :btc, for: :ltc).and_return(btc_ltc)
    service.stub(:quote).with(:sell, :ltc, for: :usd).and_return(ltc_usd)
    service.stub(:quote).with(:sell, :usd, for: :ltc).and_return(usd_ltc)

    service.stub(:quote).with(:buy, :btc, with: :usd).and_return(usd_btc)
    service.stub(:quote).with(:buy, :usd, with: :btc).and_return(btc_usd)
    service.stub(:quote).with(:buy, :ltc, with: :btc).and_return(btc_ltc)
    service.stub(:quote).with(:buy, :btc, with: :ltc).and_return(ltc_btc)
    service.stub(:quote).with(:buy, :ltc, with: :usd).and_return(usd_ltc)
    service.stub(:quote).with(:buy, :usd, with: :ltc).and_return(ltc_usd)
    service.stub(:minus_fee).and_return(1.0 - 0.002)
    service
  end

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
