# frozen_string_literal: true

FactoryBot.define do
  factory :follow do
    user { create(:user) }
    followed { create(:user) }
  end
end
