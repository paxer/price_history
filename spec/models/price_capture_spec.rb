# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PriceCapture, type: :model do
  context 'attributes' do
    it 'requires bid' do
      record = described_class.new(ask: 1, capture_time: DateTime.now, cryptocurrency_code: 'BTC', currency_code: 'AUD')
      expect(record.valid?).to be_falsey
      expect(record.errors.full_messages).to eq(["Bid can't be blank"])
    end

    it 'requires ask' do
      record = described_class.new(bid: 1, capture_time: DateTime.now, cryptocurrency_code: 'BTC', currency_code: 'AUD')
      expect(record.valid?).to be_falsey
      expect(record.errors.full_messages).to eq(["Ask can't be blank"])
    end

    it 'requires capture_time' do
      record = described_class.new(bid: 1, ask: 1, cryptocurrency_code: 'BTC', currency_code: 'AUD')
      expect(record.valid?).to be_falsey
      expect(record.errors.full_messages).to eq(["Capture time can't be blank"])
    end

    it 'requires cryptocurrency_code' do
      record = described_class.new(bid: 1, ask: 1, capture_time: DateTime.now, currency_code: 'AUD')
      expect(record.valid?).to be_falsey
      expect(record.errors.full_messages).to eq(["Cryptocurrency code can't be blank"])
    end

    it 'requires currency_code' do
      record = described_class.new(bid: 1, ask: 1, capture_time: DateTime.now, cryptocurrency_code: 'BTC')
      expect(record.valid?).to be_falsey
      expect(record.errors.full_messages).to eq(["Currency code can't be blank"])
    end
  end
end
