# frozen_string_literal: true

require 'thor'
require_relative 'main'

# CLI interface for the Cash Register
class CLI < Thor
  package_name 'Cash Register'

  include Thor::Actions

  desc 'start', 'Initializes the Cash Register'

  def start
    main.prepare
    print_welcome_guide

    loop do
      input = ask('What do you want to do today?')
      break if input.downcase == 'exit'

      handle_input(input)
    end
  end

  def handle_input(input)
    command, *args = input.split
    if main.respond_to?(command, true)
      main.send(command, *args)
      print_checkout_update
    else
      say "'#{command}' is not a supported action, you can `add`, `remove` items or exit to close"
    end
  rescue ArgumentError => e
    say e.message
  end

  private

  def main
    @main ||= Main.new
  end

  def print_welcome_guide
    say "Welcome to Amenitiz's Cash Register"
    say "Here's our current product inventory"
    say "\n"
    print_inventory
    say "\n"
    say "Commands:\nadd <product code>\nremove <product code>\nempty cart\nexit"
    say "\n"
  end

  def print_inventory
    rows = main.products.map { |p| [p.code, p.name, p.price] }
    header = ['Product Code', 'Name', 'Price']
    print_table([header] + rows)
  end

  def print_checkout_update
    say "Your cart has been updated\n"
    rows = main.checkout.line_items.map do |li|
      name = main.products.detect { |p| p.code == li.code }&.name
      [li.code, name, li.quantity, li.final_price]
    end
    rows << ['Total', '', '', main.checkout.total]

    print_table([['Product Code', 'Name', 'Quantity', 'Price']] + rows)
  end
end
