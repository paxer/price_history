# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/price_captures', type: :request do
  let(:valid_params) do
    { bid: 1.22, ask: 2.22, capture_time: DateTime.now, cryptocurrency_code: 'BTC', currency_code: 'AUD' }
  end

  describe 'GET /index' do
    let!(:btc) do
      PriceCapture.create!(
        bid: 1.22,
        ask: 2.22,
        capture_time: DateTime.now,
        cryptocurrency_code: 'BTC',
        currency_code: 'AUD'
      )
    end

    let!(:eth) do
      PriceCapture.create!(
        bid: 2.22,
        ask: 3.22,
        capture_time: DateTime.now,
        cryptocurrency_code: 'ETH',
        currency_code: 'AUD'
      )
    end

    it 'renders all currencies ordered by capture_time desc' do
      get price_captures_path
      expect(response).to be_successful
      expect(assigns(:price_captures)).to eq(PriceCapture.order(capture_time: :desc))
    end

    it 'filters by crypto currency code ETH' do
      get price_captures_path, params: { cryptocurrency_code: 'BTC' }
      expect(response).to be_successful
      expect(assigns(:price_captures).size).to eq(1)
      expect(assigns(:price_captures).first).to eq(btc)
    end

    it 'filters by crypto currency code' do
      get price_captures_path, params: { cryptocurrency_code: 'ETH' }
      expect(response).to be_successful
      expect(assigns(:price_captures).size).to eq(1)
      expect(assigns(:price_captures).first).to eq(eth)
    end
  end

  describe 'POST /create' do
    let(:data_source) { double DataSource }

    before do
      expect(DataSource).to receive(:all).and_return([data_source])
    end

    it 'invokes CapturePrice twice and redirect on success' do
      expect(CapturePrice).to receive(:call).with(data_source: data_source).and_return(double(success?: true))
      post price_captures_path, params: valid_params
      expect(flash[:notice]).to match(/Price was successfully captured/)
      expect(response).to redirect_to(price_captures_path)
    end

    it 'invokes CapturePrice twice and redirect on error' do
      expect(CapturePrice).to receive(:call).with(data_source: data_source).and_return(double(success?: false, error: 'Error Message'))
      post price_captures_path, params: valid_params
      expect(flash[:alert]).to match(/Price capture error: Error Message/)
      expect(response).to redirect_to(price_captures_path)
    end
  end
end
