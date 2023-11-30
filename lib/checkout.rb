# frozen_string_literal: true

require_relative 'line_item'

# Abstracts the checkout functionality
class Checkout
  attr_accessor :promotions, :line_items

  def initialize(promotions: [], line_items: [])
    @promotions = promotions
    @line_items = line_items
    @total = 0.00
  end

  def add_item(product)
    current_line_item = get_line_item(product.code)
    if current_line_item
      current_line_item.quantity += 1
    else
      line_items << LineItem.from_product(product)
    end
    recalculate_with(product.code)
  end

  def remove_item(code)
    current_line_item = get_line_item(code)
    raise ArgumentError, "Item with code #{code} does not exist" unless current_line_item

    current_line_item.quantity -= 1
    line_items.delete_if { |li| li.quantity < 1 }
    recalculate_with(code)
  end

  def total
    line_items.sum(&:final_price)
  end

  def empty!
    self.line_items = []
  end

  private

  def get_line_item(code)
    line_items.find { |li| li.code == code }
  end

  def recalculate_with(product_code)
    reset_line_items(product_code)
    promotions.find do |promo|
      promo.promotable_products.include?(product_code)
    end&.apply(self)
  end

  def reset_line_items(item_code)
    line_items.find { |li| li.code == item_code }&.reset!
  end
end
