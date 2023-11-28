# frozen_string_literal: true

require 'promotion'

# Applies 0,50 discount when buying 3 or more of a product
class BulkDiscountPromo < Promotion
  DISCOUNT_AMOUNT = 0.50

  def applicable?(entity)
    super(entity) && expected_quantity?(entity)
  end

  def apply(checkout)
    applicable_line_items(checkout).each { |li| li.price -= DISCOUNT_AMOUNT }
  end

  private

  def expected_quantity?(entity)
    if entity.respond_to?(:line_items)
      entity.line_items.any? { |li| expected_quantity?(li) }
    elsif entity.respond_to?(:quantity)
      entity.quantity >= 3
    else
      false
    end
  end
end
