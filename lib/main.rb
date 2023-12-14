# frozen_string_literal: true

require './lib/product'
require './lib/buy_one_get_one_promo'
require './lib/bulk_discount_promo'
require './lib/bulk_price_drop_promo'
require './lib/checkout'

# Application's entry point
class Main
  attr_reader :products, :promotions, :checkout

  def prepare
    prepare_products
    prepare_promotions
    @checkout = Checkout.new(promotions: @promotions)
  end

  def add(product_code)
    product = @products.detect { |p| p.code == product_code }
    raise ArgumentError, "Product #{product_code} does not exist" unless product

    @checkout.add_item(product)
  end

  def remove(product_code)
    item_in_cart = @checkout.line_items.any? { |li| li.code == product_code }
    raise ArgumentError, "Your cart does not include any #{product_code} yet" unless item_in_cart

    @checkout.remove_item(product_code)
  end

  def empty(_)
    @checkout.empty!
  end

  private

  def prepare_products
    @products = [
      Product.new(code: 'GR1', name: 'Green Tea', price: 3.11),
      Product.new(code: 'SR1', name: 'Strawberries', price: 5.00),
      Product.new(code: 'CF1', name: 'Coffee', price: 11.23)
    ]
  end

  def prepare_promotions
    @promotions = [
      BuyOneGetOnePromo.new(promotable: 'GR1'),
      BulkDiscountPromo.new(promotable: 'SR1'),
      BulkPriceDropPromo.new(promotable: 'CF1')
    ]
  end
end
