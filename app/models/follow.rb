# frozen_string_literal: true

class Follow < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :followed, class_name: 'User', counter_cache: :followers_count

  validates :user_id, uniqueness: { scope: :followed_id, message: :already_followed }
  validate :validate_user_cannot_follow_self

  def validate_user_cannot_follow_self
    return if followed.blank?
    return unless user_id == followed_id

    errors.add(:base, :cannot_follow_self)
  end
end
