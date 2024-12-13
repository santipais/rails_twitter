# frozen_string_literal: true

FactoryBot.define do
  factory :like do
    user { create(:user) }
    tweet { create(:tweet) }
  end
end
