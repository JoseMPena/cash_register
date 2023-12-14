# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    code { 'SR1' }
    name { 'Strawberries' }
    price { 5.00 }
  end
end
