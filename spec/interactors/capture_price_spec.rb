# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CapturePrice, type: :model do
  context '#call' do
    let(:data_source) { DataSource.new(cryptocurrency_code: 'BTC', currency_code: 'AUD') }
    let(:response_body) do
      '{
        "volume_24h": "83.85000000",
        "volume": "19.71000000",
        "transition_time": "2018-06-21T07:50:00Z", "status": "continuous",
        "session": 3190,
        "prev_close": "9211.00000000",
        "last": "9210.00000000",
        "current_time": "2018-06-21T02:08:23.832377Z",
        "bid": "9211.00000000",
        "ask": "9242.00000000"
        }'
    end
    let(:success_response) { double('SuccessResponse', success?: true, body: response_body) }
    let(:failed_response) { double('SuccessResponse', success?: false, status: '500', body: 'error') }

    it 'fails if data_source argument was not passed' do
      result = described_class.call
      expect(result.failure?).to be_truthy
      expect(result.error).to eq('An instance of DataSource must be passed')
    end

    it 'fails if API request was unsuccessful' do
      expect(Faraday).to receive(:get).with(data_source.url).and_return(failed_response)
      result = described_class.call(data_source: data_source)
      expect(result.failure?).to be_truthy
      expect(result.error).to eq("Failed to access the API url #{data_source.url}, status: 500")
    end

    it 'calls API endpoint and creates a PriceCapture model if no PriceCapture exists' do
      expect(Faraday).to receive(:get).with(data_source.url).and_return(success_response)
      expect do
        described_class.call(data_source: data_source)
      end.to change { PriceCapture.count }.by(1)
      price_capture = PriceCapture.last
      expect(price_capture.bid).to eq(9211)
      expect(price_capture.ask).to eq(9242)
      expect(price_capture.capture_time).to eq(DateTime.parse('2018-06-21T02:08:23.832377Z'))
      expect(price_capture.cryptocurrency_code).to eq(data_source.cryptocurrency_code)
      expect(price_capture.currency_code).to eq(data_source.currency_code)
    end

    it 'calls API endpoint and does not creates a PriceCapture model if existing PriceCapture has the same capture_time' do
      PriceCapture.create!(
        bid: 9211,
        ask: 9242,
        capture_time: DateTime.parse('2018-06-21T02:08:23.832377Z'),
        cryptocurrency_code: 'BTC',
        currency_code: 'AUD'
      )
      expect(Faraday).to receive(:get).with(data_source.url).and_return(success_response)
      expect do
        described_class.call(data_source: data_source)
      end.to_not change { PriceCapture.count }
    end

    it 'calls API endpoint creates a PriceCapture model if existing PriceCapture is older than incoming' do
      PriceCapture.create!(
        bid: 9211,
        ask: 9242,
        capture_time: DateTime.parse('2018-06-21T02:08:22.832377Z'),
        cryptocurrency_code: 'BTC',
        currency_code: 'AUD'
      )
      expect(Faraday).to receive(:get).with(data_source.url).and_return(success_response)
      expect do
        described_class.call(data_source: data_source)
      end.to change { PriceCapture.count }.by(1)
    end
  end
end
