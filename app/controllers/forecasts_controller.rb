# frozen_string_literal: true

class ForecastsController < ApplicationController
  def show
    addr = Address.find_or_create_by(forecast_params)
    @in_cache = cached?(addr)

    @forecast = Rails.cache.fetch("forecasts/#{forecast_params[:zip]}", expires_in: 30.minutes) do
      result = WeatherForecaster.new(address: addr).call
      forecast = Forecast.find_or_create_by(address: addr)
      forecast.response = result.value_or({})
      forecast.save
      forecast
    end
  end

  # Only allow a list of trusted parameters through.
  private def forecast_params
    params.permit(:zip, :street)
  end

  private def cached?(addr)
    fc1 = Forecast.find_by(address: addr)
    !fc1.nil? ? fc1.cached? : false
  end
end
