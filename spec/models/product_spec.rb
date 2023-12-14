# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product do
  subject { build(:product) }

  let(:product) { subject }

  let(:invalid_product) { build(:product, :invalid_attributes) }

  context 'accessors' do
    it { is_expected.to respond_to(:code) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:price) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(product).to be_valid
    end

    it 'is not valid without a code' do
      expect(invalid_product).not_to be_valid
      expect(invalid_product.errors[:code]).to include("can't be blank")
    end

    it 'is not valid without a name' do
      expect(invalid_product).not_to be_valid
      expect(invalid_product.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without a price' do
      product = build(:product, price: nil)
      expect(product).not_to be_valid
      expect(product.errors[:price]).to include("can't be blank")
    end

    it 'is not valid with a negative price' do
      expect(invalid_product).not_to be_valid
      expect(invalid_product.errors[:price]).to include('must be greater than or equal to 0')
    end
  end
end
