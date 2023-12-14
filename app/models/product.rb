# frozen_string_literal: true

# nodoc
class Product < ApplicationRecord
  validates :code, :name, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
