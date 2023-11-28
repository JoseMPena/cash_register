# frozen_string_literal: true

require 'promotion'
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
    applicable_line_items(checkout)
      .each { |li| li.price -= discounted_amount }
  end
end
