# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /tweets/:tweet_id/likes', type: :request do
  let!(:user) { create(:user) }
  let!(:tweet) { create(:tweet) }
  let(:tweet_id) { tweet.id }

  subject { post tweet_likes_path(tweet_id) }

  context 'when the user is authenticated' do
    before { sign_in user }

    context 'when user likes another user tweet' do
      context 'when the tweet was not liked' do
        it 'returns a succsseful response' do
          subject
          expect(response).to have_http_status(:successful)
        end

        it 'creates the like' do
          expect { subject }.to change(tweet.reload.likes, :count).from(0).to(1)
        end
      end

      context 'when the tweet was already liked' do
        before { create(:like, user: user, tweet: tweet) }

        it 'returns an unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not create a like' do
          expect { subject }.not_to change(Like, :count)
        end
      end
    end

    context 'when user likes his own tweet' do
      let(:tweet) { create(:tweet, user: user) }

      it 'returns an unprocessable entity response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a like' do
        expect { subject }.not_to change(Like, :count)
      end
    end

    context 'when the tweet_id is incorrect' do
      let(:tweet_id) { 'invalid_id' }

      it 'returns a not found response' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context 'when the user is not authenticated' do
    it 'returns an unauthorized response' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'does not delete the like' do
      expect { subject }.not_to change(Like, :count)
    end
  end
end
