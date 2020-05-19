# frozen_string_literal: true

class DataSource
  attr_reader :cryptocurrency_code, :currency_code

  def initialize(cryptocurrency_code:, currency_code:)
    @cryptocurrency_code = cryptocurrency_code
    @currency_code = currency_code
  end

  def self.all
    [
      new(cryptocurrency_code: 'BTC', currency_code: 'AUD'),
      new(cryptocurrency_code: 'ETH', currency_code: 'AUD')
    ]
  end

  def url
    "https://data.exchange.coinjar.com/products/#{cryptocurrency_code}#{currency_code}/ticker"
  end
end
