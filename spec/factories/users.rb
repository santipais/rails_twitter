# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: 5..10) }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6, max_length: 8) }
    first_name { Faker::Name.first_name }
    birthdate { Faker::Date.birthday(min_age: 18) }

    trait :confirmed do
      confirmed_at { Time.current }
    end
  end
end
