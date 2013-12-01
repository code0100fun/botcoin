require 'spec_helper'

describe BotCoin::Trade do

  it 'trades ltc for btc' do
    trade = BotCoin::Trade.new(25, :ltc, for: :btc, at: 0.03)
    expect(trade.pair).to eq(:ltc_btc)
    expect(trade.a).to eq(:ltc)
    expect(trade.b).to eq(:btc)
    expect(trade.amount).to eq(25)
    expect(trade.price).to eq(0.03)
    expect(trade.action).to eq(:sell)
  end

  it 'trades btc for usd' do
    trade = BotCoin::Trade.new(2, :btc, for: :usd, at: 900)
    expect(trade.pair).to eq(:btc_usd)
    expect(trade.a).to eq(:btc)
    expect(trade.b).to eq(:usd)
    expect(trade.amount).to eq(2)
    expect(trade.price).to eq(900)
    expect(trade.action).to eq(:sell)
  end

  it 'trades usd for ltc' do
    trade = BotCoin::Trade.new(60, :usd, for: :ltc, at: 30)
    expect(trade.pair).to eq(:ltc_usd)
    expect(trade.a).to eq(:usd)
    expect(trade.b).to eq(:ltc)
    expect(trade.amount).to eq(60)
    expect(trade.price).to eq(30)
    expect(trade.action).to eq(:buy)
  end

end
