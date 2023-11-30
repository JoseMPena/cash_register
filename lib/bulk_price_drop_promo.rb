# frozen_string_literal: true

require 'bigdecimal'
require_relative 'promotion'
require_relative 'mixins/bulk_promotable'

# Adjusts the price to a given fraction on applicable items
class BulkPriceDropPromo < Promotion
  PRICE_DROP_FRACTION = '2/3'

  include BulkPromotable

  attr_reader :discount_fraction

  def initialize(promotable:, discount_fraction: PRICE_DROP_FRACTION)
    super(promotable:)
    @discount_fraction = discount_fraction.to_r
  end

  def apply(checkout)
    applicable_line_items(checkout).each do |li|
      li.final_price = discounted_price_quantity(li.original_price, li.quantity)
    end
  end

  private

  def discounted_price_quantity(price, quantity)
    discounted_unit_price = BigDecimal((price * discount_fraction).to_s)
    (discounted_unit_price * quantity).round(2).to_f
  end
end
