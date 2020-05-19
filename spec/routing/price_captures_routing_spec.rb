# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PriceCapturesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/price_captures').to route_to('price_captures#index')
    end

    it 'routes to #create' do
      expect(post: '/price_captures').to route_to('price_captures#create')
    end
  end
end
