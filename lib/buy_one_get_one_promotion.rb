# frozen_string_literal: true

require 'promotion'

# Applies promotion rules to add a free item for each applicable product in the checkout
class BuyOneGetOnePromotion < Promotion
  def apply(checkout)
    applicable_line_items(checkout)
      .each { |li| li.quantity *= 2 }
  end
end
