# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet
  has_many :follows, dependent: :destroy
  has_many :following_users, -> { order(created_at: :desc) }, through: :follows, source: :followed
  has_many :following_users_tweets, through: :following_users, source: :tweets
  has_many :following_users_likes, through: :following_users, source: :likes

  has_many :followers, foreign_key: :followed_id, class_name: 'Follow', dependent: :destroy, inverse_of: :followed
  has_many :followers_users, -> { order(created_at: :desc) }, through: :followers, source: :user
  has_one_attached :profile_image

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :username, presence: true, length: { in: 2..20 }, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9_]*\z/ }
  validates :encrypted_password, presence: true, if: :confirmed? || :password_required?
  validates :first_name, :last_name, presence: true, length: { minimum: 2 }
  validates :bio, length: { maximum: 160 }
  validates :website, format: { with: %r{https?://(www.)?[^\W]*\.com} }, allow_blank: true
  validates :birthdate, comparison: { less_than: 18.years.ago }
  validate  :validate_password_confirmation, unless: :password_required?
  validate  :validate_acceptable_image

  def full_name
    "#{first_name} #{last_name}"
  end

  def password_match?
    return false unless password.present? && password_confirmation.present?

    password == password_confirmation
  end

  def no_password?
    encrypted_password.blank?
  end

  # Overrides devise password_required? to be required only if it is being set, but not for new records
  def password_required?
    return false unless persisted?

    password.present? || password_confirmation.present?
  end

  def to_param
    username
  end

  def following?(user)
    following_users.include?(user)
  end

  private

  def validate_acceptable_image
    return unless profile_image.attached?

    errors.add(:profile_image, :big) unless profile_image.blob.byte_size <= 1.megabyte
    acceptable_types = ['image/png', 'image/jpeg']
    return if acceptable_types.include?(profile_image.blob.content_type)

    errors.add(:profile_image, :type)
  end

  def validate_password_confirmation
    return if password.blank? && password_confirmation.blank?

    errors.add(:password_confirmation, I18n.t('errors.messages.confirmation', attribute: 'password')) if password != password_confirmation
  end
end
