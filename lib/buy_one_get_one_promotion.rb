# frozen_string_literal: true

require 'promotion'

# Applies promotion rules to add a free item for each applicable product in the checkout
class BuyOneGetOnePromotion < Promotion

  def apply(checkout)
    checkout.line_items
            .select { |li| applicable?(li) }
            .each { |li| li.quantity *= 2 }
  end
end
