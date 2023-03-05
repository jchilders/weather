# frozen_string_literal: true

class Address < ApplicationRecord
  validates :street, presence: true
  validates :zip, presence: true
  validates :zip, presence: true, format: /\A\d{5}(-\d{4})?\z/
end
