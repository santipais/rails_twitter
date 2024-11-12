# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /users', type: :request do
  let(:user) { User.last }
  let(:email) { 'jhondoe@gmail.com' }
  let(:password) { 'password' }
  let(:password_confirmation) { 'password' }
  let(:username) { 'jhon' }

  let(:params) do
    {
      user: { email:, password:, password_confirmation:, username: }
    }
  end

  subject { post user_registration_path, params:, as: :json }

  context 'when the params are correct' do
    let(:json) { response.parsed_body }

    it 'returns a successful response' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns the user' do
      subject

      expect(json['id']).to eq(user.id)
      expect(json['email']).to eq(email)
      expect(json['username']).to eq(username)
    end

    it 'creates a user' do
      expect { subject }.to change(User, :count).from(0).to(1)
    end

    it 'user is not confirmed' do
      subject
      expect(user.confirmed_at).to eq(nil)
    end
  end
end
