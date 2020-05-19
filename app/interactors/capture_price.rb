# frozen_string_literal: true

class CapturePrice
  include Interactor

  def call
    data_source = context.data_source
    context.fail!(error: 'An instance of DataSource must be passed') if data_source.nil?

    response = Faraday.get data_source.url

    if response.success?
      attrs = JSON.parse(response.body)
      if last_price_capture.nil?
        create_price_capture(attrs)
      elsif last_price_capture.capture_time.to_datetime < DateTime.parse(attrs['current_time'])
        create_price_capture(attrs)
      end
    else
      context.fail!(error: "Failed to access the API url #{data_source.url}, status: #{response.status}")
    end
  end

  def create_price_capture(attrs)
    price_capture = PriceCapture.new(
      bid: attrs['bid'],
      ask: attrs['ask'],
      capture_time: attrs['current_time'],
      cryptocurrency_code: context.data_source.cryptocurrency_code,
      currency_code: context.data_source.currency_code
    )

    unless price_capture.save
      context.fail!("Unable to save a new Price Capture #{price_capture.errors.full_messages.join}")
    end
  end

  def last_price_capture
    PriceCapture.where(
      cryptocurrency_code: context.data_source.cryptocurrency_code,
      currency_code: context.data_source.currency_code
    ).order(capture_time: :asc).last
  end
end
