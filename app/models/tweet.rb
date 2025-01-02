# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user
  has_many_attached :images

  validates :content, presence: true, length: { maximum: 280 }
  validates :images, content_type: { in: ['image/png', 'image/jpeg', 'image/gif'], message: :type }, size: { less_than: 1.megabyte, message: :big }

  scope :feed, lambda { |user|
    return all if user.blank?

    where(id: user.following_users_tweets).or(
      where(id: user.following_users_likes.select(:tweet_id))
    ).excluding(user.tweets).distinct
  }
end
