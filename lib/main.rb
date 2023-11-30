# frozen_string_literal: true

require 'thor'
require './lib/product'
require './lib/buy_one_get_one_promo'
require './lib/bulk_discount_promo'
require './lib/bulk_price_drop_promo'
require './lib/checkout'

# Application's entry point
class Main < Thor
  package_name 'Cash Register'

  include Thor::Actions

  desc 'prepare', 'Creates application dependencies'
  def prepare
    prepare_products
    prepare_promotions
    @checkout = Checkout.new(promotions: @promotions)
  end

  desc 'start', 'Initializes the Cash Register'

  def start
    say "Welcome to Amenitiz's Cash Register"
    say "Here's our current product inventory"
    say "\n"
    print_inventory
    say "\n"
    say "You can add products to your shopping cart saying 'add <product code>' \n"
    say "You can also remove products from your cart saying 'remove <product code>' "
    say "\n"
    ask 'What do you want to do today?'
  end

  desc 'add CODE', 'Adds a product to the checkout'

  def add(product_code)
    product = @products.detect { |p| p.code == product_code }
    raise ArgumentError, "Product #{product_code} does not exist" unless product

    @checkout.add_item(product)
    print_total
  end

  desc 'remove CODE', 'Removes a product from the checkout'

  def remove(product_code)
    item_in_cart = @checkout.line_items.any? { |li| li.code == product_code }
    raise ArgumentError, "Your cart does not include any #{product_code} yet" unless item_in_cart

    @checkout.remove_item(product_code)
    print_total
  end

  desc 'print_total', 'Shows the current checkout total'

  def print_total
    puts @checkout.total
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

  def print_inventory
    header = ['Product Code', 'Name', 'Price']
    rows = [
      ['GR1', 'Green Tea', '3.11€'],
      ['SR1', 'Strawberries', '5.00€'],
      ['CF1', 'Coffee', '11.23€']
    ]

    print_table([header] + rows)
  end
end
