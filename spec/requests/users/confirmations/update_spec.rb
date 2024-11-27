# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PATCH /user/confirmation', type: :request do
  before { @user = create(:user) }
  let(:confirmation_token) { @user.confirmation_token }
  let(:password) { 'secret' }
  let(:password_confirmation) { 'secret' }
  let(:user) { User.find_by(confirmation_token: confirmation_token) }

  let(:params) do
    {
      user: { password:, password_confirmation: }, confirmation_token:
    }
  end

  subject { patch update_user_confirmation_path, params:, as: :json }

  context 'when the params are correct' do
    let(:json) { response.parsed_body }

    it 'returns a successful response' do
      subject
      expect(response).to have_http_status(:found)
    end

    it 'doesnt creates a user' do
      expect { subject }.not_to change(User, :count)
    end

    it 'user is confirmed' do
      subject
      expect(user.confirmed_at).not_to eq(nil)
    end
  end

  context 'when the params are incorrect' do
    let(:json) { response.parsed_body }
    context 'when password is missing' do
      let(:password) { nil }

      it 'returns an unprocessable entity response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not return a valid client and access token' do
        subject
        expect(response.header['Authorization']).to be_nil
      end

      it 'does not confirms a user' do
        subject
        expect(user.confirmed_at).to eq(nil)
      end
    end

    context 'when password is too short' do
      let(:password) { 'Ab123' }

      it 'returns an unprocessable entity response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not return a valid user and access token' do
        subject
        expect(response.header['Authorization']).to be_nil
      end

      it 'does not confirms a user' do
        subject
        expect(user.confirmed_at).to eq(nil)
      end
    end

    context 'when passwords do not match' do
      let(:password) { 'NewPassword123' }
      let(:password_confirmation) { 'NewPassword1234' }

      it 'returns an unprocessable entity response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not return a valid user and access token' do
        subject
        expect(response.header['Authorization']).to be_nil
      end

      it 'does not confirms a user' do
        subject
        expect(user.confirmed_at).to eq(nil)
      end
    end
  end
end
