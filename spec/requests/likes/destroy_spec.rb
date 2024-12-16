# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE tweets/:tweet_id/likes/:id', type: :request do
  let!(:user) { create(:user) }
  let!(:tweet) { create(:tweet) }
  let!(:like) { create(:like, user: user, tweet: tweet) }
  let(:like_id) { like.id }
  let(:tweet_id) { tweet.id }

  subject { delete tweet_like_path(tweet_id, like_id) }

  context 'when user is authenticated' do
    before { sign_in user }

    it 'returns a successful response' do
      subject
      expect(response).to have_http_status(:successful)
    end

    it 'deletes the like' do
      expect { subject }.to change(Like, :count).from(1).to(0)
    end

    context 'when the like_id is invalid' do
      context 'when the like does not exist' do
        let(:like_id) { 'invalid_id' }

        it 'returns a not found response' do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when the like does not belong to the user' do
        let!(:like) { create(:like, tweet: tweet) }

        it 'returns a not found response' do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when the tweet is invalid' do
      context 'when the tweet does not exist' do
        let(:tweet_id) { 'invalid_id' }

        it 'returns a not found response' do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  context 'when user is not authenticated' do
    it 'redirects to sign in' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'does not delete the like' do
      expect { subject }.not_to change(Like, :count)
    end
  end
end
