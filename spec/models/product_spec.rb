# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product do
  subject { described_class.new(attributes_for(:product)) }

  context 'accessors' do
    it { is_expected.to respond_to(:code) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:price) }
  end
end
