# frozen_string_literal: true

require 'rspec'
require 'promotion'

describe Promotion do
  describe 'accessors' do
    let(:promotable_products) { %w[some product references] }
    let(:promotion) { described_class.new(promotable: promotable_products) }

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
    it 'raises a NotImplementedError' do
      expect { subject.applicable?({}) }.to raise_error(NotImplementedError)
    end
  end
end
