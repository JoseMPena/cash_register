# frozen_string_literal: true

# Abstracts common functionality for Bulk Promotions
module BulkPromotable
  BULK_QUANTITY = 3

  def applicable?(entity)
    super(entity) && expected_quantity?(entity)
  end

  private

  def expected_quantity?(entity)
    if entity.respond_to?(:line_items)
      entity.line_items.any? { |li| expected_quantity?(li) }
    elsif entity.respond_to?(:quantity)
      entity.quantity >= BULK_QUANTITY
    else
      false
    end
  end
end
