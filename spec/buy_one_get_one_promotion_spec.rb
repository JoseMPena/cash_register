# frozen_string_literal: true

require 'rspec'
require 'buy_one_get_one_promotion'

describe BuyOneGetOnePromotion do
  let(:applicable_products) { %w[FOO BAR] }
  let(:non_applicable_products) { %w[BAZ] }
  let(:checkout) { instance_double("Checkout") }
  let(:foo) { instance_double("LineItem", code: 'FOO', price: 1.99, quantity: 1) }
  let(:baz) { instance_double("LineItem", code: 'BAZ', price: 1.99, quantity: 1) }

  describe '#applicable?' do
    context 'when it has promotable products' do
      let(:promo) { described_class.new(promotable: applicable_products) }

      context 'and checkout includes promotable products' do
        before { allow(checkout).to receive(:line_items).and_return([foo]) }

        it { expect(promo.applicable?(checkout)).to be true }
      end

      context 'and checkout includes non-promotable products' do
        before { allow(checkout).to receive(:line_items).and_return([baz]) }

        it { expect(promo.applicable?(checkout)).to be false }
      end
    end

    context 'when it has no promotable products' do
      let(:promo) { described_class.new(promotable: []) }

      context 'and checkout includes products' do
        before { allow(checkout).to receive(:line_items).and_return([foo]) }

        it { expect(promo.applicable?(checkout)).to be false }
      end

      context 'and it scanned non-promotable products' do
        before { allow(checkout).to receive(:line_items).and_return([baz]) }

        it { expect(subject.applicable?(checkout)).to be false }
      end
    end
  end
end