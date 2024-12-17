# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE users/:user_id/follow', type: :request do
  let!(:user) { create(:user) }
  let!(:followed) { create(:user) }
  let(:followed_id) { followed.username }

  subject { delete user_follow_path(followed) }

  context 'when user is authenticated' do
    before { sign_in user }

    context 'when the followed_id is valid' do
      context 'when the follow exists' do
        let!(:follow) { create(:follow, user: user, followed: followed) }

        it 'returns a successful response' do
          subject
          expect(response).to have_http_status(:successful)
        end

        it 'deletes the follow' do
          expect { subject }.to change(Follow, :count).from(1).to(0)
        end

        it 'the user is no longer following the followed user' do
          expect { subject }.to change(user.reload.follows, :count).from(1).to(0)
        end

        it 'the followed user is no longer followed by the user' do
          expect { subject }.to change(followed.reload.followers, :count).from(1).to(0)
        end
      end

      context 'when the follow does not exist' do
        it 'returns a not found response' do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when the followed_id is invalid' do
      let(:followed_id) { 'invalid_id' }

      it 'returns a not found response' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context 'when user is not authenticated' do
    it 'redirects to sign in' do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'does not delete the follow' do
      expect { subject }.not_to change(Follow, :count)
    end
  end
end
