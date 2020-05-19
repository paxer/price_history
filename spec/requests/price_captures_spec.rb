# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/price_captures', type: :request do
  let(:valid_params) do
    { bid: 1.22, ask: 2.22, capture_time: DateTime.now, cryptocurrency_code: 'BTC', currency_code: 'AUD' }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      PriceCapture.create!(valid_params)
      get price_captures_path
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    it 'creates a new PriceCapture' do
      expect do
        post price_captures_path, params: valid_params
      end.to change(PriceCapture, :count).by(1)
    end

    it 'redirects to the created price_capture' do
      post price_captures_path, params: valid_params
      expect(response).to redirect_to(price_captures_path)
    end
  end
end
