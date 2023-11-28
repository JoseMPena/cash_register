# frozen_string_literal: true

require 'rspec'
require 'promotion'

describe Promotion do
  let(:promotable_products) { %w[some product references] }
  let(:promotion) { described_class.new(promotable: promotable_products) }

  describe 'accessors' do
    it 'holds and returns promotable products' do
      expect(promotion.promotable_products).to eq(promotable_products)
    end
  end

  describe '#apply' do
    it 'raises a NotImplementedError' do
      expect { subject.apply({}) }.to raise_error(NotImplementedError)
    end
  end

  describe '#applicable?' do
    let(:checkout) { instance_double("Checkout") }
    let(:foo) { instance_double("LineItem", code: 'product', price: 1.99, quantity: 1) }
    let(:baz) { instance_double("LineItem", code: 'baz', price: 1.99, quantity: 1) }

    context 'when it has promotable products and checkout includes promotable products' do
      before { allow(checkout).to receive(:line_items).and_return([foo]) }

      it { expect(promotion.applicable?(checkout)).to be true }
    end

    context 'when it has promotable products and checkout includes non-promotable products' do
      before { allow(checkout).to receive(:line_items).and_return([baz]) }

      it { expect(promotion.applicable?(checkout)).to be false }
    end

    context 'when it has no promotable products' do
      let(:promotion) { described_class.new(promotable: []) }

      context 'and checkout includes products' do
        before { allow(checkout).to receive(:line_items).and_return([foo]) }

        it { expect(promotion.applicable?(checkout)).to be false }
      end

      context 'and it scanned non-promotable products' do
        before { allow(checkout).to receive(:line_items).and_return([baz]) }

        it { expect(subject.applicable?(checkout)).to be false }
      end
    end
  end
end
