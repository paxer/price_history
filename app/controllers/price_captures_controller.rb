# frozen_string_literal: true

class PriceCapturesController < ApplicationController
  def index
    @price_captures = PriceCapture.all
  end

  def create
    @price_capture = PriceCapture.new

    if @price_capture.save
      redirect_to price_captures_path, notice: 'Price capture was successfully created.'
    else
      redirect_to price_captures_path, alert: 'Price capture error.'
    end
  end
end
