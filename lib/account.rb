require 'btce'

class Account

  def balance
    info = Btce::TradeAPI.new_from_keyfile.get_info
    funds = info["return"]["funds"]
    { :usd => funds["usd"], :ltc => funds["ltc"], :btc => funds["btc"] }
  end
end
