# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'price_captures/index', type: :view do
  context 'when price_captures is no blank' do
    before(:each) do
      assign(:price_captures,
             [
               PriceCapture.create!(
                 bid: '9.99',
                 ask: '10.99',
                 cryptocurrency_code: 'BTC',
                 currency_code: 'AUD',
                 capture_time: DateTime.new(2020, 2, 3, 4, 5)
               ),
               PriceCapture.create!(
                 bid: '19.99',
                 ask: '29.99',
                 cryptocurrency_code: 'ETH',
                 currency_code: 'USD',
                 capture_time: DateTime.new(2020, 2, 3, 4, 6)
               )
             ])
    end

    it 'renders a list of price_captures' do
      render
      assert_select 'tr>td', text: '9.99', count: 1
      assert_select 'tr>td', text: '10.99', count: 1
      assert_select 'tr>td', text: 'BTC', count: 1
      assert_select 'tr>td', text: 'AUD', count: 1
      assert_select 'tr>td', text: '2020-02-03 04:05:00', count: 1

      assert_select 'tr>td', text: '19.99', count: 1
      assert_select 'tr>td', text: '29.99', count: 1
      assert_select 'tr>td', text: 'ETH', count: 1
      assert_select 'tr>td', text: 'USD', count: 1
      assert_select 'tr>td', text: '2020-02-03 04:06:00', count: 1
    end
  end

  context 'when price_captures is blank' do
    before(:each) do
      assign(:price_captures, [])
    end

    it 'does not render a blank list of price_captures' do
      render
      assert_select 'table', count: 0
      assert_select 'tr>td', count: 0
    end
  end
end
