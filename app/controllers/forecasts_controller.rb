# frozen_string_literal: true

class ForecastsController < ApplicationController
  def show
    @in_cache = cached?

    @forecast = Rails.cache.fetch("forecasts/#{forecast_params[:zip]}", expires_in: 30.minutes) do
      addr = Address.find_or_create_by(forecast_params)
      result = WeatherForecaster.new(address: addr).call
      if result.success?
        forecast = Forecast.find_or_create_by(address: addr)
        forecast.response = result.success
        forecast.save
        forecast
      else
        flash[:error] = "Error getting forecast for zip #{forecast_params[:zip]}"
        Rails.logger.error(result.failure)
        nil
      end
    end
  end

  # Only allow a list of trusted parameters through.
  private def forecast_params
    params.permit(:zip, :street)
  end

  private def cached?
    Rails.cache.exist?("forecasts/#{forecast_params[:zip]}")
  end
end
