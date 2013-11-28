require 'rspec'
require 'rspec/mocks'
require 'account'

describe Account do
  describe '#balance' do
    subject(:account) { Account.new }
    it 'fetches balances from server' do
      balance = account.balance
      expect(balance[:usd]).to_not be_nil
      expect(balance[:ltc]).to_not be_nil
      expect(balance[:btc]).to_not be_nil
    end
  end
end
