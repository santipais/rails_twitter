# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:birthdate) }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { is_expected.to validate_uniqueness_of(:username).ignoring_case_sensitivity }
    it { is_expected.to validate_length_of(:username).is_at_least(2).is_at_most(20) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
    it { is_expected.to validate_length_of(:first_name).is_at_least(2) }
    it { is_expected.to validate_length_of(:last_name).is_at_least(2) }
    it { is_expected.to allow_value('test@example.com').for(:email) }
    it { is_expected.not_to allow_value('invalid_email').for(:email) }
    it { is_expected.to allow_value('username').for(:username) }
    it { is_expected.not_to allow_value('invalid/username').for(:username) }
    it { is_expected.to allow_value('https://validwebsite.com').for(:website) }
    it { is_expected.not_to allow_value('https://invalid.website.com').for(:website) }
    it { is_expected.to validate_size_of(:profile_image).less_than(1.megabyte) }
    it { is_expected.to validate_content_type_of(:profile_image).allowing('image/png', 'image/jpeg') }
    it { is_expected.to validate_content_type_of(:profile_image).rejecting('text/plain', 'text/xml') }

    context 'when user is not confirmed' do
      subject { build(:user, :unconfirmed) }
      it { is_expected.not_to validate_presence_of(:encrypted_password) }
    end

    context 'when user is confirmed' do
      subject { build(:user) }
      it { is_expected.to validate_presence_of(:encrypted_password) }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:tweets).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:liked_tweets).through(:likes).source(:tweet) }
    it { is_expected.to have_many(:follows).dependent(:destroy) }
    it { is_expected.to have_many(:following_users).through(:follows).source(:followed) }
    it { is_expected.to have_many(:followers).with_foreign_key(:followed_id).class_name('Follow').dependent(:destroy).inverse_of(:followed) }
    it { is_expected.to have_many(:followers_users).through(:followers).source(:user) }
    it { is_expected.to have_many(:following_users_tweets).through(:following_users).source(:tweets) }
    it { is_expected.to have_many(:following_users_likes).through(:following_users).source(:likes) }
    it { is_expected.to have_one_attached(:profile_image) }
  end
end
