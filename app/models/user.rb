# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tweets, dependent: :destroy

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :username, presence: true, length: { in: 2..20 }, uniqueness: { case_insensitive: true }
  validates :encrypted_password, presence: true, if: :confirmed? || :password_required?
  validates :first_name, :last_name, presence: true, length: { minimum: 2 }
  validates :bio, length: { maximum: 160 }
  validates :website, format: { with: %r{https?://(www.)?[^\W]*\.com} }, allow_blank: true
  validates :birthdate, comparison: { less_than: 18.years.ago }
  validate  :validate_password_confirmation, unless: :password_required?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

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

  private

  def validate_password_confirmation
    return if password.blank? && password_confirmation.blank?

    errors.add(:password_confirmation, I18n.t('errors.messages.confirmation', attribute: 'password')) if password != password_confirmation
  end
end
