# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: 5..10) }
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birthdate { Faker::Date.birthday(min_age: 18) }

    trait :confirmed do
      confirmed_at { Time.current }
    end
    trait :password do
      password { Faker::Internet.password(min_length: 6, max_length: 8) }
      password_confirmation { password }
    end
  end
end
