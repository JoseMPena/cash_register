# frozen_string_literal: true

require 'rails_helper'
require 'bulk_price_drop_promo'

describe BulkPriceDropPromo do
  let(:promo) { described_class.new(promotable: %(GR1)) }

  describe '#applicable?' do
    context 'when line_items quantity is < 3' do
      let(:coffee) { instance_double('LineItem', code: 'GR1', quantity: 2) }

      it { expect(promo.applicable?(coffee)).to be false }
    end

    context 'when line_items quantity is 3' do
      let(:coffee) { instance_double('LineItem', code: 'GR1', quantity: 3) }

      it { expect(promo.applicable?(coffee)).to be true }
    end

    context 'when line_items quantity is > 3' do
      let(:coffee) { instance_double('LineItem', code: 'GR1', quantity: 4) }

      it { expect(promo.applicable?(coffee)).to be true }
    end

    context 'when checkout includes multiple products one of which is promotable' do
      let(:coffee) { instance_double('LineItem', code: 'GR1', quantity: 4) }
      let(:tea) { instance_double('LineItem', code: 'CF1', quantity: 4) }
      let(:checkout) { instance_double('Checkout', line_items: [coffee, tea]) }

      it { expect(promo.applicable?(checkout)).to be true }
    end

    context 'when checkout code is not promotable' do
      let(:coffee) { instance_double('LineItem', code: 'GR2', quantity: 20) }
      let(:checkout) { instance_double('Checkout', line_items: [coffee]) }

      it { expect(promo.applicable?(checkout)).to be false }
    end
  end

  describe '#apply' do
    let(:coffee) { instance_double('LineItem', code: 'GR1', original_price: 11.23, quantity: 1) }
    let(:checkout) { instance_double('Checkout', line_items: [coffee]) }

    before { allow(coffee).to receive(:final_price=) }

    context 'when it is applicable' do
      before { allow(promo).to receive(:applicable?).with(anything).and_return true }

      it 'adjusts the price with a discount of 2/3 of the original price' do
        promo.apply(checkout)
        expect(coffee).to have_received(:final_price=).with(7.49)
      end
    end

    context 'when is not applicable' do
      before { allow(promo).to receive(:applicable?).with(anything).and_return false }

      it 'does not adjust the price with discounts' do
        promo.apply(checkout)
        expect(coffee).not_to have_received(:final_price=)
      end
    end

    context 'when it is applicable and there are multiple products in checkout' do
      let(:coffee2) { instance_double('LineItem', code: 'GR2') }
      let(:strawberry) { instance_double('LineItem', code: 'SR1') }
      let(:checkout) { instance_double('Checkout', line_items: [coffee]) }

      before do
        allow(promo).to receive(:applicable?).with(anything).and_return true
        allow(coffee2).to receive(:final_price=)
        allow(strawberry).to receive(:final_price=)
      end

      it 'adjusts the price on the promotable item only' do
        promo.apply(checkout)
        expect(coffee2).not_to have_received(:final_price=)
        expect(strawberry).not_to have_received(:final_price=)
        expect(coffee).to have_received(:final_price=).with(7.49)
      end
    end
  end
end
