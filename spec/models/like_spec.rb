# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'validations' do
    let(:user) { create(:user) }
    let(:tweet) { create(:tweet, user: user) }

    context 'when user likes a tweet' do
      let(:like) { build(:like, user: user) }

      it 'is valid' do
        expect(like.valid?).to eq(true)
      end
    end
    context 'when user likes their own tweet' do
      let(:like_own_tweet) { build(:like, user: user, tweet: tweet) }

      it 'is invalid' do
        expect(like_own_tweet.valid?).to eq(false)
        expect(like_own_tweet.errors.full_messages).to include("Users #{I18n.t('errors.likes.own_tweet')}")
      end
    end

    context 'when user likes the same tweet more than once' do
      let(:like) { create(:like) }
      let(:like_same_tweet) { build(:like, user: like.user, tweet: like.tweet) }

      it 'is invalid' do
        expect(like_same_tweet.valid?).to eq(false)
        expect(like_same_tweet.errors.full_messages).to include("User #{I18n.t('errors.likes.already_liked')}")
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:tweet) }
  end
end
