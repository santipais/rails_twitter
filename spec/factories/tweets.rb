# frozen_string_literal: true

FactoryBot.define do
  factory :tweet do
    content { Faker::String.random(length: 1..280) }
    user { build(:user) }
  end
end
