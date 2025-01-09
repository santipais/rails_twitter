# frozen_string_literal: true

class Tweet < ApplicationRecord
  include PgSearch::Model

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

  pg_search_scope :search_tweets,
                  against: {
                    content: 'A'
                  },
                  associated_against: {
                    user: {
                      username: 'B',
                      first_name: 'C',
                      last_name: 'C'
                    }
                  },
                  using: {
                    tsearch: {
                      any_word: true,
                      prefix: true,
                      dictionary: 'english'
                    }
                  },
                  order_within_rank: 'tweets.created_at DESC'
end
