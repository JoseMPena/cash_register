# frozen_string_literal: true

require 'line_item'

# Abstracts the checkout functionality
class Checkout
  def initialize(promotions: [], line_items: {})
    @current_promotions = promotions
    @current_line_items = line_items
    @total = 0.00
  end

  def promotions
    @current_promotions
  end

  def line_items
    @current_line_items.values
  end

  def add_item(product)
    item = LineItem.from_product(product)
    @current_line_items[item.code] ||= item
    @current_line_items[item.code].quantity += 1
    recalculate
  end

  def remove_item(code)
    raise ArgumentError, "Item with code #{code} does not exist" unless
      @current_line_items[code]

    @current_line_items[code].quantity -= 1
    @current_line_items.delete_if { |_k, v| v.quantity < 1 }
    recalculate
  end

  def total
    @current_line_items.values.sum(&:final_price)
  end

  private

  def recalculate
    reset_line_items
    @current_promotions.each { |promo| promo.apply(self) }
  end

  def reset_line_items
    @current_line_items.each_value(&:reset!)
  end
end
