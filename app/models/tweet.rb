# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  validates :content, presence: true, length: { maximum: 280 }

  scope :feed, lambda { |user|
    return all if user.blank?

    where(id: user.following_users_tweets).or(
      where(id: user.following_users_likes.select(:tweet_id))
    ).excluding(user.tweets).distinct
  }
end
