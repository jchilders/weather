# frozen_string_literal: true

class Forecast < ApplicationRecord
  belongs_to :address

  delegate :city, :zip, to: :address

  def cached?
    Rails.cache.exist?(cache_key)
  end

  def cache_key
    "forecasts/#{zip}"
  end

  def temperature_current
    response["temperature_current"]
  end

  def temperature_high
    response["temperature_high"]
  end

  def temperature_low
    response["temperature_low"]
  end

  # @return [Array[Hash]]
  def forecasts
    @forecasts ||= response["forecast"].any? ? response["forecast"] : []
  end
end
