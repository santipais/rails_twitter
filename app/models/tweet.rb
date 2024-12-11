# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  validates :content, presence: true, length: { maximum: 280 }
end
