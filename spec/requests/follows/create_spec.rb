# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /users/:user_id/follow', type: :request do
  let!(:user) { create(:user) }
  let!(:followed) { create(:user) }
  let(:followed_id) { followed.username }

  subject { post user_follow_path(followed_id) }

  context 'when the user is authenticated' do
    before { sign_in user }

    context 'when the user follows another user' do
      context 'when the user was not followed' do
        it 'returns a succsseful response' do
          subject
          expect(response).to have_http_status(:found)
        end

        it 'creates the follow' do
          expect { subject }.to change(Follow, :count).from(0).to(1)
        end

        it 'sets the current user as the follower' do
          expect { subject }.to change(followed.reload.followers, :count).from(0).to(1)
        end

        it 'does not sets the followed user as the follower' do
          expect { subject }.not_to change(user.reload.followers, :count)
        end
      end

      context 'when the user was already followed' do
        before { create(:follow, user: user, followed: followed) }

        it 'returns an unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not create a follow' do
          expect { subject }.not_to change(Follow, :count)
        end
      end
    end

    context 'when a user follows himself' do
      let!(:followed) { user }

      it 'returns an unprocessable entity response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a follow' do
        expect { subject }.not_to change(Follow, :count)
      end
    end

    context 'when the followed_id is invalid' do
      let(:followed_id) { 'invalid_id' }

      it 'returns a not found response' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context 'when the user is not authenticated' do
    it 'redirects to sign in' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'does not deletes a follow' do
      expect { subject }.not_to change(Follow, :count)
    end
  end
end
