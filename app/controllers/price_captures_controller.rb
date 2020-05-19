# frozen_string_literal: true

class PriceCapturesController < ApplicationController
  before_action :load_price_captures, only: :index

  def index; end

  def create
    results = DataSource.all.map do |ds|
      CapturePrice.call(data_source: ds)
    end

    if results.all?(&:success?)
      redirect_to price_captures_path, notice: 'Price was successfully captured.'
    else
      redirect_to price_captures_path, alert: "Price capture error: #{results.map(&:error).join(', ')}"
    end
  end

  private

  def load_price_captures
    @price_captures = if params[:cryptocurrency_code]
                        PriceCapture.where(cryptocurrency_code: params[:cryptocurrency_code]).order(capture_time: :desc)
                      else
                        PriceCapture.order(capture_time: :desc)
                      end
  end
end
