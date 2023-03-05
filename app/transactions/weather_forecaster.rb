# frozen_string_literal: true

# Get the (JSON) weather forcast data for a given an `Address`.
#
# This class is a convenience/wrapper class for calling the APIs necesary to
# translate between an address and what the NWS requires.
class WeatherForecaster
  include Dry::Transaction

  step :geocode
  step :nws_grid
  step :nws_forecast

  def initialize(address:, **args)
    @address = address
    super
  end

  private def geocode
    Census::Geocoder.new.call(@address)
  end

  private def nws_grid(**kwargs)
    Nws::Points.new.call(kwargs)
  end

  private def nws_forecast(**kwargs)
    Nws::Forecast.new.call(**kwargs)
  end
end
