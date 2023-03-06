# frozen_string_literal: true

# Get the weather forcast data for a given an `Address`.
#
# This class is a convenience/wrapper class for calling the various APIs necesary to
# translate between an address and what the NWS requires. Broadly, the steps required are:
#
# 1. Get the latitude/longitude (geocoordinates) for a given address
# 2. Translate the geocoordinates into an NWS grid, consisting of a grid_id, and x/y coordinates
# 3. Get the current, high, and low temperatures for that grid
# 4. Get the forecast data for that grid
class WeatherForecaster
  include Dry::Transaction

  step :geocode
  step :nws_grid
  map :update_address
  step :temperatures
  map :forecast

  def initialize(address:, **args)
    @address = address
    super
  end

  private def geocode
    Census::Geocoder.new.call(@address)
  end

  private def nws_grid(**kwargs)
    result = Nws::Points.new.call(kwargs)
    @grid = result.success if result.success?
    result
  end

  private def update_address(result)
    @address.city = result[:city] if @address.city.nil?
    @address.state = result[:state] if @address.state.nil?
    @address.save
  end

  private def temperatures
    Nws::Temperatures.new.call(@grid)
  end

  private def forecast(**kwargs)
    result = Nws::Forecast.new.call(@grid)
    kwargs.merge!({ forecast: result.value_or([]) })
  end
end
