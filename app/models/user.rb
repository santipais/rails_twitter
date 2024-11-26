# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :username, presence: true, length: { in: 2..20 }, uniqueness: { case_insensitive: true }
  validates :encrypted_password, presence: true
  validates :first_name, :last_name, presence: true, length: { minimum: 2 }
  validates :bio, length: { maximum: 160 }
  validates :website, format: { with: %r{https?://(www.)?[^\W]*\.com} }, allow_blank: true
  validates :birthdate, comparison: { less_than: 18.years.ago }

  def full_name
    "#{first_name} #{last_name}"
  end
end
