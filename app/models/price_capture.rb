# frozen_string_literal: true

class PriceCapture < ApplicationRecord
  validates :bid, :ask, :capture_time, :cryptocurrency_code, :currency_code, presence: true
end
