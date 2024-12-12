# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tweet, counter_cache: true

  validates :user_id, uniqueness: { scope: :tweet_id, message: I18n.t('errors.likes.already_liked') }
  validate :validate_user_cannot_like_own_tweet

  private

  def validate_user_cannot_like_own_tweet
    return if tweet.blank?
    return unless user_id == tweet.user_id

    errors.add(:users, I18n.t('errors.likes.own_tweet'))
  end
end
