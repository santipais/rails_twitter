# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /users', type: :request do
  let(:user) { User.last }
  let(:email) { 'jhondoe@gmail.com' }
  let(:password) { 'password' }
  let(:password_confirmation) { 'password' }
  let(:username) { 'jhon' }
  let(:first_name) { 'Jhon' }
  let(:birthdate) { '01/01/1999' }

  let(:params) do
    {
      user: { email:, password:, password_confirmation:, username:, birthdate:, first_name: }
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
      expect(json['birthdate'].to_date).to eq(birthdate.to_date)
      expect(json['first_name']).to eq(first_name)
    end

    it 'creates a user' do
      expect { subject }.to change(User, :count).from(0).to(1)
    end

    it 'user is not confirmed' do
      subject
      expect(user.confirmed_at).to eq(nil)
    end
  end

  context 'when the params are incorrect' do
    let(:json) { response.parsed_body }
    context 'when email is missing' do
      let(:email) { nil }

      it 'returns an unprocessable entity response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        subject
        expect(json['errors']['email']).to include("can't be blank")
      end

      it 'does not return a valid client and access token' do
        subject
        expect(response.header['Authorization']).to be_nil
      end

      it 'does not create a user' do
        expect { subject }.not_to change(User, :count)
      end
    end

    context 'when email is already taken' do
      before { create(:user, email: 'jhondoe@gmail.com') }

      it 'returns an unprocessable entity response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        subject
        expect(json['errors']['email']).to include('has already been taken')
      end

      it 'does not return a valid client and access token' do
        subject
        expect(response.header['Authorization']).to be_nil
      end

      it 'does not create a user' do
        expect { subject }.not_to change(User, :count)
      end
    end

    context 'when password is too short' do
      let(:password) { 'Ab123' }

      it 'returns an unprocessable entity response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        subject
        expect(json['errors']['password']).to include('is too short (minimum is 6 characters)')
      end

      it 'does not return a valid user and access token' do
        subject
        expect(response.header['Authorization']).to be_nil
      end

      it 'does not create a user' do
        expect { subject }.not_to change(User, :count)
      end
    end

    context 'when passwords do not match' do
      let(:password) { 'NewPassword123' }
      let(:password_confirmation) { 'NewPassword1234' }

      it 'returns an unprocessable entity response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        subject
        expect(json['errors']['password_confirmation']).to include('doesn\'t match Password')
      end

      it 'does not return a valid user and access token' do
        subject
        expect(response.header['Authorization']).to be_nil
      end

      it 'does not create a user' do
        expect { subject }.not_to change(User, :count)
      end
    end
  end
end
