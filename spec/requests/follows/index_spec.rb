# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET users/:user_id/follows', type: :request do
  let!(:user) { create(:user, followers_users: create_list(:user, 2), following_users: create_list(:user, 3)) }
  let(:params) { {} }
  let(:follow_users) { @controller.instance_variable_get(:@follow_users) }

  subject { get user_follows_path(user), params: }

  context 'when current_user is present' do
    let(:current_user) { create(:user) }

    before { create(:follow, user: current_user, followed: user.following_users.last) }
    before { create(:follow, user: current_user, followed: user.followers_users.last) }
    before { sign_in current_user }

    context 'when no params are provided' do
      it 'returns a successful response' do
        subject
        expect(response).to have_http_status(:successful)
      end

      it 'assigns the following_users of user to @follows_user' do
        subject
        expect(follow_users).to eq(user.following_users)
      end

      it 'assigns the followed_by_current_user to true for the user followed by current_user' do
        subject
        expect(follow_users.last.followed_by_current_user).to be_truthy
      end

      it 'assigns the followed_by_current_user to false for the user not followed by current_user' do
        subject
        expect(follow_users.first.followed_by_current_user).to be_falsey
      end
    end

    context 'when params are provided' do
      context 'when followers is true' do
        let(:params) { { followers: 'true' } }

        subject { get user_follows_path(user), params: { followers: 'true' } }

        it 'returns a successful response' do
          subject
          expect(response).to have_http_status(:successful)
        end

        it 'assigns the followers_users of user to @follows_user' do
          subject
          expect(follow_users).to eq(user.followers_users)
        end

        it 'assigns the followed_by_current_user to true for the user followed by current_user' do
          subject
          expect(follow_users.last.followed_by_current_user).to be_truthy
        end

        it 'assigns the followed_by_current_user to false for the user not followed by current_user' do
          subject
          expect(follow_users.first.followed_by_current_user).to be_falsey
        end
      end

      context 'when any other param is provided' do
        let(:params) { { followers: 'other' } }

        it 'returns a successful response' do
          subject
          expect(response).to have_http_status(:successful)
        end

        it 'assigns the following_users of user to @follows_user' do
          subject
          expect(follow_users).to eq(user.following_users)
        end

        it 'assigns the followed_by_current_user to true for the user followed by current_user' do
          subject
          expect(follow_users.last.followed_by_current_user).to be_truthy
        end

        it 'assigns the followed_by_current_user to false for the user not followed by current_user' do
          subject
          expect(follow_users.first.followed_by_current_user).to be_falsey
        end
      end
    end
  end

  context 'when current_user is not present' do
    context 'when no params are provided' do
      it 'returns a successful response' do
        subject
        expect(response).to have_http_status(:successful)
      end

      it 'assigns the following_users of user to @follows_user' do
        subject
        expect(follow_users).to eq(user.following_users)
      end

      it 'assigns the followed_by_current_user to false for all the follow_users' do
        subject
        expect(follow_users.sample.followed_by_current_user).to be_falsey
      end
    end

    context 'when params are provided' do
      context 'when followers is true' do
        subject { get user_follows_path(user), params: { followers: 'true' } }

        it 'returns a successful response' do
          subject
          expect(response).to have_http_status(:successful)
        end

        it 'assigns the followers_users of user to @follows_user' do
          subject
          expect(follow_users).to eq(user.followers_users)
        end

        it 'assigns the followed_by_current_user to false for all the follow_users' do
          subject
          expect(follow_users.sample.followed_by_current_user).to be_falsey
        end
      end

      context 'when any other param is provided' do
        let(:params) { { followers: 'other' } }

        it 'returns a successful response' do
          subject
          expect(response).to have_http_status(:successful)
        end

        it 'assigns the following_users of user to @follows_user' do
          subject
          expect(follow_users).to eq(user.following_users)
        end

        it 'assigns the followed_by_current_user to false for all the follow_users' do
          subject
          expect(follow_users.sample.followed_by_current_user).to be_falsey
        end
      end
    end
  end
end
