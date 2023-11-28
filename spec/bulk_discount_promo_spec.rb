# frozen_string_literal: true

require 'rspec'
require 'bulk_discount_promo'

describe BulkDiscountPromo do
  let(:promo) { described_class.new(promotable: %(FOO)) }

  describe '#applicable?' do
    context 'when line_items quantity is < 3' do
      let(:foo) { instance_double(LineItem, code: 'FOO', price: 1.99, quantity: 1) }

      it { expect(promo.applicable?(foo)).to be false }
    end

    context 'when line_items quantity is 3' do
      let(:foo) { instance_double(LineItem, code: 'FOO', price: 1.99, quantity: 3) }

      it { expect(promo.applicable?(foo)).to be true }
    end

    context 'when line_items quantity is > 3' do
      let(:foo) { instance_double(LineItem, code: 'FOO', price: 1.99, quantity: 1000) }

      it { expect(promo.applicable?(foo)).to be true }
    end

    context 'when line_item code is not promotable' do
      let(:foo) { instance_double(LineItem, code: 'BAR', price: 1.99, quantity: 20) }

      it { expect(promo.applicable?(foo)).to be false }
    end
  end

  describe '#apply' do
    let(:foo) { instance_double(LineItem, code: 'FOO', price: 1.99) }
    let(:checkout) { instance_double(Checkout, line_items: [foo]) }

    before { allow(foo).to receive(:price=).with(anything) }

    context 'when it is applicable' do
      before { allow(promo).to receive(:applicable?).with(anything).and_return true }

      it 'adjusts the price with a discount of 0,50' do
        promo.apply(checkout)
        expect(foo).to have_received(:price=).with(1.49)
      end
    end

    context 'when is not applicable' do
      before { allow(promo).to receive(:applicable?).with(anything).and_return false }

      it 'does not adjust the price with discounts' do
        promo.apply(checkout)

        expect(foo).not_to have_received(:price)
      end
    end
  end
end
