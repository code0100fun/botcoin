require 'btce'

class Profit

  def initialize(btc_amt, ltc_amt)
    @btc_amt = btc_amt
    @ltc_amt = ltc_amt
  end

  def update
    btc_ticker = Btce::Ticker.new "btc_usd"
    ltc_ticker = Btce::Ticker.new "ltc_usd"
    @btc_usd = btc_ticker.json["ticker"]["last"]
    @ltc_usd = ltc_ticker.json["ticker"]["last"]
  end

  def calculate
    (@ltc_amt * @ltc_usd) - (@btc_amt * @btc_usd)
  end

  def log
    profit = calculate
    "#{@btc_amt}@$#{@btc_usd} - #{@ltc_amt}@$#{@ltc_usd} = Profit: $#{profit}"
  end

end
