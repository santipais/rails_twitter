# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :email, presence: true, uniqueness: { case_sensitive: true }
  validates :username, presence: true, length: { minimum: 3 }, uniqueness: { case_sensitive: true }
  validates :encrypted_password, presence: true
end
