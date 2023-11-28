# frozen_string_literal: true

require 'promotion'
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
    applicable_line_items(checkout)
      .each { |li| li.price = discounted_price(li.price) }
  end

  private

  def discounted_price(price)
    (price * discount_fraction).round(2)
  end
end
