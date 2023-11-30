# frozen_string_literal: true

require_relative 'promotion'

# Applies promotion rules to add a free item for each applicable product in the checkout
class BuyOneGetOnePromo < Promotion
  def apply(checkout)
    applicable_line_items(checkout).each do |li|
      li.final_price = discounted_price_quantity(li.original_price, li.quantity)
    end
  end

  private

  def discounted_price_quantity(price, quantity)
    # multiply price by quantity and THEN subtract the price for half the quantity
    ((price * quantity) - (price * (quantity / 2))).round(2)
  end
end
