# frozen_string_literal: true

require 'rails_helper'
require 'checkout'
require_relative '../lib/buy_one_get_one_promo'
require_relative '../lib/bulk_discount_promo'
require_relative '../lib/bulk_price_drop_promo'

describe Checkout do
  let(:checkout) { described_class.new }

  describe '#line_items' do
    it 'starts empty' do
      expect(checkout.line_items).to eq []
    end
  end

  describe '#promotions' do
    it 'starts empty' do
      expect(checkout.promotions).to eq []
    end
  end

  describe '#add_item' do
    let(:product) { instance_double('Product', code: 'PR1', price: 1.99) }

    it 'adds new items' do
      checkout.add_item(product)
      expect(checkout.line_items.count).to eq 1
    end

    it 'increases the quantity of existing items' do
      checkout.add_item(product)

      expect { checkout.add_item(product) }
        .not_to change(checkout.line_items, :count)

      expect(checkout.line_items.map(&:quantity)).to eq [2]
    end
  end

  describe '#remove_item' do
    let(:product) { instance_double('Product', code: 'PR1', price: 1.99) }

    before { checkout.add_item(product) }

    it 'removes an item with quantity 1' do
      checkout.remove_item('PR1')
      expect(checkout.line_items.count).to eq 0
    end

    it 'removes only the specified product' do
      checkout.add_item(instance_double('Product', code: 'PR2', price: 1.99))
      checkout.remove_item('PR2')

      expect(checkout.line_items.count).to eq 1
      expect(checkout.line_items.map(&:code)).to eq ['PR1']
    end

    it 'decreases the quantity of an item when quantity > 1' do
      checkout.add_item(product)
      checkout.remove_item('PR1')

      expect(checkout.line_items.map(&:quantity)).to eq [1]
    end
  end

  describe '#total' do
    let(:tea) { instance_double('Product', code: 'GR1', price: 3.11) }
    let(:strawberry) { instance_double('Product', code: 'SR1', price: 5.00) }
    let(:coffee) { instance_double('Product', code: 'CF1', price: 11.23) }

    it 'returns the sum of all product prices' do
      checkout.add_item(tea)
      checkout.add_item(coffee)
      checkout.add_item(strawberry)

      expect(checkout.total).to eq 19.34
    end

    # Integration tests
    context 'when buy-on-get-one promo is added' do
      let(:two_for_one) { BuyOneGetOnePromo.new(promotable: ['GR1']) }
      let(:checkout) { described_class.new(promotions: [two_for_one]) }

      before do
        2.times { checkout.add_item(tea) }
      end

      it 'applies the promotion' do
        expect(checkout.line_items.map(&:quantity)).to eq [2]
        expect(checkout.total).to eq 3.11
      end
    end

    context 'when bulk_discount promo is added' do
      let(:bulk_discount) { BulkDiscountPromo.new(promotable: ['SR1']) }
      let(:checkout) { described_class.new(promotions: [bulk_discount]) }

      before do
        2.times { checkout.add_item(strawberry) }
        checkout.add_item(tea)
        checkout.add_item(strawberry)
      end

      it 'applies the promotion' do
        expect(checkout.line_items.map(&:quantity)).to eq [3, 1]
        expect(checkout.total).to eq 16.61
      end
    end

    context 'when bulk_price_drop promo is added' do
      let(:bulk_price_drop) { BulkPriceDropPromo.new(promotable: ['CF1']) }
      let(:checkout) { described_class.new(promotions: [bulk_price_drop]) }

      before do
        checkout.add_item(tea)
        checkout.add_item(coffee)
        checkout.add_item(strawberry)
        2.times { checkout.add_item(coffee) }
      end

      it 'applies the promotion' do
        expect(checkout.line_items.map(&:quantity)).to eq [1, 3, 1]
        expect(checkout.total).to eq 30.57
      end
    end
  end
end
