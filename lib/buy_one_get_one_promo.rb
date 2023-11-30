# frozen_string_literal: true

require_relative 'promotion'

# Applies promotion rules to add a free item for each applicable product in the checkout
class BuyOneGetOnePromo < Promotion
  def apply(checkout)
    applicable_line_items(checkout)
      .each { |li| li.quantity *= 2 }
  end
end
