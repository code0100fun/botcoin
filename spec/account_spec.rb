require 'spec_helper'

describe Account do
  describe '#balance' do

    before do
      stub_request(:post, "https://btc-e.com/tapi").to_return(
        :status => 200, :body => account_response
      )
    end

    let(:account_response) { MultiJson.dump({
        success: 1,
        return: {
          funds: {
            usd: 100,
            ltc: 25,
            btc: 1
          },
          rights: {
            info: 1,
            trade: 1,
            withdraw: 0
          }
        }
      })
    }

    subject(:account) { Account.new }
    it 'fetches balances from server' do
      balance = account.balance
      expect(balance[:usd]).to be(100)
      expect(balance[:ltc]).to be(25)
      expect(balance[:btc]).to be(1)
    end
  end
end
