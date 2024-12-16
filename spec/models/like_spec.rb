# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  subject { build(:like) }

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:tweet_id).with_message(I18n.t('errors.likes.already_liked')) }

    context 'when user likes a tweet' do
      let(:user) { create(:user) }

      subject(:like) { build(:like, user: user) }

      it 'is valid' do
        expect(like.valid?).to eq(true)
      end

      context 'when user likes their own tweet' do
        let(:tweet) { create(:tweet, user: user) }

        subject(:like) { build(:like, user: user, tweet: tweet) }

        it 'is invalid' do
          expect(like.valid?).to eq(false)
          expect(like.errors.full_messages).to include("Users #{I18n.t('errors.likes.own_tweet')}")
        end
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:tweet).counter_cache(true) }
  end
end
