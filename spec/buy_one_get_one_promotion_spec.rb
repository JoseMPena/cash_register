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

  describe '#apply' do
    let(:promo) { subject }

    context 'when line_items have low quantity' do
      before do
        [foo, baz].each { |mock| allow(mock).to receive(:quantity=).with(anything) }
        allow(checkout).to receive(:line_items).and_return [foo, baz]
      end

      it 'increases the quantity of applicable line_items by 1' do
        allow(promo).to receive(:applicable?).with(anything).and_return true

        promo.apply(checkout)
        expect(foo).to have_received(:quantity=).with(2)
        expect(baz).to have_received(:quantity=).with(2)
      end

      it 'does not increase the quantity of non-applicable line_items' do
        allow(promo).to receive(:applicable?).with(foo).and_return false
        allow(promo).to receive(:applicable?).with(baz).and_return true

        promo.apply(checkout)
        expect(foo).not_to have_received(:quantity=)
        expect(baz).to have_received(:quantity=).with(2)
      end
    end

    context 'when line_items have high quantity' do
      let(:bar) { instance_double("LineItem", code: 'BAZ', price: 1.99, quantity: 3) }

      before do
        allow(promo).to receive(:applicable?).with(bar).and_return true
        allow(bar).to receive(:quantity=).with(anything)
        allow(checkout).to receive(:line_items).and_return [bar]
      end

      it 'doubles the quantity to meet buy-one-get-one rule' do
        promo.apply(checkout)

        expect(bar).to have_received(:quantity=).with(6)
      end
    end
  end
end
