# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    code { 'SR1' }
    name { 'Strawberries' }
    price { 5.00 }

    trait :invalid_attributes do
      code { nil }
      name { nil }
      price { -5 }
    end
  end
end
