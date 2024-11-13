# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: 5..10) }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6, max_length: 8) }
  end
end
