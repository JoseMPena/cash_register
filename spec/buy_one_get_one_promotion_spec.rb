# frozen_string_literal: true

require 'rspec'
require 'buy_one_get_one_promo'

describe BuyOneGetOnePromo do
  let(:checkout) { instance_double('Checkout') }
  let(:foo) do
    instance_double('LineItem',
                    code: 'FOO',
                    original_price: 1.99,
                    final_price: 1.99,
                    quantity: 1)
  end
  let(:baz) do
    instance_double('LineItem',
                    code: 'BAZ',
                    original_price: 1.99,
                    final_price: 1.99,
                    quantity: 1)
  end

  describe '#apply' do
    let(:promo) { subject }

    context 'when line_items have low quantity' do
      before do
        [foo, baz].each do |mock|
          allow(mock).to receive(:final_price=)
        end
        allow(checkout).to receive(:line_items).and_return [foo, baz]
      end

      it 'does not modify the price' do
        allow(promo).to receive(:applicable?).with(anything).and_return true

        promo.apply(checkout)
        expect(foo.final_price).to eq 1.99
      end
    end

    context 'when line_items have a promotable quantity' do
      let(:bar) do
        instance_double('LineItem',
                        code: 'BAZ',
                        original_price: 1.99,
                        final_price: 1.99,
                        quantity: 3)
      end

      before do
        allow(promo).to receive(:applicable?).with(bar).and_return true
        allow(bar).to receive(:final_price=)
        allow(checkout).to receive(:line_items).and_return [bar]
      end

      it 'adjusts the item prices to meet buy-one-get-one rule' do
        promo.apply(checkout)

        expect(bar).to have_received(:final_price=).with(bar.final_price * 2)
      end

      it 'does not increase the quantity of non-applicable line_items' do
        allow(promo).to receive(:applicable?).with(bar).and_return false

        promo.apply(checkout)
        expect(bar).not_to have_received(:final_price=)
      end
    end
  end
end
