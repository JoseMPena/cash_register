# frozen_string_literal: true

require 'bigdecimal'
require_relative 'promotion'
require_relative 'mixins/bulk_promotable'

# Applies 0,50 discount when buying 3 or more of a product
class BulkDiscountPromo < Promotion
  DISCOUNTED_AMOUNT = 0.50

  include BulkPromotable

  attr_reader :discounted_amount

  def initialize(promotable:, discount: DISCOUNTED_AMOUNT)
    super(promotable:)
    @discounted_amount = discount
  end

  def apply(checkout)
    applicable_line_items(checkout).each do |li|
      li.final_price = discounted_price_quantity(li.original_price, li.quantity)
    end
  end

  private

  def discounted_price_quantity(price, quantity)
    discounted_unit_price = BigDecimal((price - discounted_amount).to_s)
    (discounted_unit_price * quantity).round(2)
  end
end
