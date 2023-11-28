# frozen_string_literal: true

require 'promotion'

# Applies promotion rules to add a free item for each applicable product in the checkout
class BuyOneGetOnePromotion < Promotion
  def applicable?(entity)
    if entity.respond_to?(:code)
      promotable_products.include?(entity.code)
    elsif entity.respond_to?(:line_items)
      entity.line_items.any? { |li| applicable?(li) }
    else
      false
    end
  end

  def apply(checkout)
    checkout.line_items
            .select { |li| applicable?(li) }
            .each { |li| li.quantity += 1 }
  end
end
