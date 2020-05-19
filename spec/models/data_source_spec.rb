# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataSource, type: :model do
  context '.all' do
    it 'returns all data sources' do
      records = described_class.all
      expect(records.size).to eq(2)
      expect(records.first.cryptocurrency_code).to eq('BTC')
      expect(records.first.currency_code).to eq('AUD')
      expect(records.first.url).to eq('https://data.exchange.coinjar.com/products/BTCAUD/ticker')
      expect(records.second.cryptocurrency_code).to eq('ETH')
      expect(records.second.currency_code).to eq('AUD')
      expect(records.second.url).to eq('https://data.exchange.coinjar.com/products/ETHAUD/ticker')
    end
  end

  context '#url' do
    it 'returns url based on cryptocurrency_code and currency_code' do
      data_source = described_class.new(cryptocurrency_code: 'BTC', currency_code: 'AUD')
      expect(data_source.url).to eq('https://data.exchange.coinjar.com/products/BTCAUD/ticker')
      data_source = described_class.new(cryptocurrency_code: 'ZOL', currency_code: 'USD')
      expect(data_source.url).to eq('https://data.exchange.coinjar.com/products/ZOLUSD/ticker')
    end
  end
end
