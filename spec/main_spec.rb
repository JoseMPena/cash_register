# frozen_string_literal: true

require 'rspec'

require './lib/buy_one_get_one_promo'
require './lib/bulk_discount_promo'
require './lib/bulk_price_drop_promo'
require './lib/checkout'
require './lib/main'

RSpec.describe Main do
  subject(:main) { described_class.new }

  describe '#prepare' do
    before { main.prepare }

    it 'prepares products' do
      products = main.products
      expect(products.size).to eq(3)
      expect(products.map(&:code)).to eq %w[GR1 SR1 CF1]
    end

    it 'prepares promotions' do
      promotions = main.promotions

      expect(promotions.size).to eq(3)
      expect(promotions.map(&:promotable_products)).to eq %w[GR1 SR1 CF1]
    end

    it 'prepares a checkout' do
      checkout = main.checkout

      expect(checkout).to be_a(Checkout)
    end
  end

  describe '#add' do
    before do
      main.prepare
    end

    it 'tries to add a product to the checkout' do
      coffee = main.products.detect { |p| p.code == 'CF1' }
      checkout = main.checkout
      allow(checkout).to receive(:add_item)

      main.add('CF1')
      expect(checkout).to have_received(:add_item).with(coffee)
    end

    it 'raises ArgumentError if the product code does not exist' do
      expect { main.add('NoExists') }.to raise_error(ArgumentError, 'Product NoExists does not exist')
    end
  end

  describe '#remove' do
    let(:checkout) { main.checkout }
    let(:coffee) { main.products.detect { |p| p.code == 'CF1' } }

    before do
      main.prepare
      allow(checkout).to receive(:line_items).and_return [coffee]
      allow(checkout).to receive(:remove_item)
    end

    it 'tries to remove a product from checkout' do
      main.remove('CF1')
      expect(checkout).to have_received(:remove_item).with('CF1')
    end

    it 'raises ArgumentError if the product code does not exist' do
      expect { main.add('NoExists') }.to raise_error(ArgumentError, 'Product NoExists does not exist')
    end
  end
end
