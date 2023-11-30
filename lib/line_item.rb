# frozen_string_literal: true

# Represents a products belonging to a checkout
class LineItem
  attr_reader :code, :original_price
  attr_accessor :quantity, :final_price

  def initialize(code:, price:, quantity: 1)
    @code = code
    @original_price = price
    @quantity = quantity
    reset!
  end

  def self.from_product(product)
    new(code: product.code, price: product.price)
  end

  def reset!
    self.final_price = original_price * quantity
  end
end
