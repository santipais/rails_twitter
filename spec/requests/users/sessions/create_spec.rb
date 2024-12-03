# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /users/sign_in', type: :request do
  let!(:user) { create(:user) }
  let(:email) { user.email }
  let(:password) { user.password }

  let(:params) do
    {
      user: { email:, password: }
    }
  end

  subject { post user_session_path, params:, as: :json }

  context 'when the params are correct' do
    let(:json) { response.parsed_body }

    it 'returns a successful response' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns the user' do
      subject
      expect(json['id']).to eq(user.id)
      expect(json['email']).to eq(user.email)
    end

    it 'does not creates a user' do
      expect { subject }.to_not change(User, :count)
    end

    it 'user is logged' do
      subject
      expect(controller.current_user.id).to eq(user.id)
    end
  end

  context 'when the params are incorrect' do
    let(:json) { response.parsed_body }
    let(:password) { 'invalid' }

    it 'returns an unauthorized response' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns error' do
      subject
      expect(response.body).to include('Invalid Email or password.')
    end

    it 'does not creates a user' do
      expect { subject }.to_not change(User, :count)
    end
  end
end
