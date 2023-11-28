# frozen_string_literal: true

require 'rspec'
require 'product'

describe Product do
  subject { described_class.new(code: 'PR1', name: 'A Product', price: 1.99) }

  context 'accessors' do
    it { is_expected.to respond_to(:code) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:price) }
  end
end
