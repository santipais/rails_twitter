# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /user', type: :request do
  let!(:user) { create(:user) }
  let(:bio) { 'New Bio' }
  let(:first_name) { 'New' }
  let(:last_name) { 'Name' }
  let(:birthdate) { '01/01/1999' }
  let(:website) { 'https://newwebsite.com' }
  let(:profile_image) { fixture_file_upload(Rails.root.join('spec/support/assets/profile.png'), 'image/png') }
  before { sign_in user }

  let(:params) do
    {
      user: { bio:, website:, birthdate:, first_name:, last_name:, profile_image: }
    }
  end

  subject { patch update_user_path, params: }

  context 'when the params are correct' do
    it 'returns a successful response' do
      subject
      expect(response).to have_http_status(:found)
    end

    it 'returns the user' do
      subject
      expect(user.birthdate.to_date).to eq(birthdate.to_date)
      expect(user.first_name).to eq(first_name)
      expect(user.last_name).to eq(last_name)
      expect(user.website).to eq(website)
      expect(user.bio).to eq(bio)
      expect(user.profile_image).to be_attached
    end

    it 'does not creates a user' do
      expect { subject }.not_to change(User, :count)
    end

    it 'user is confirmed' do
      subject
      expect(user.confirmed_at).not_to eq(nil)
    end
  end

  context 'when the params are incorrect' do
    context 'when first_name is missing' do
      let(:first_name) { nil }

      it 'returns an unprocessable entity response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        subject
        expect(user.errors['first_name']).to include("can't be blank", 'is too short (minimum is 2 characters)')
      end

      it 'does not create a user' do
        expect { subject }.not_to change(User, :count)
      end
    end

    context 'when last_name is missing' do
      let(:last_name) { nil }

      it 'returns an unprocessable entity response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        subject
        expect(user.errors['last_name']).to include("can't be blank", 'is too short (minimum is 2 characters)')
      end

      it 'does not create a user' do
        expect { subject }.not_to change(User, :count)
      end
    end

    context 'when birthdate is missing' do
      let(:birthdate) { nil }

      it 'returns an unprocessable entity response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        subject
        expect(user.errors['birthdate']).to include("can't be blank")
      end

      it 'does not create a user' do
        expect { subject }.not_to change(User, :count)
      end
    end

    context 'when birthdate is less than 18 years ago' do
      let(:birthdate) { Time.current }

      it 'returns an unprocessable entity response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        subject
        expect(user.errors['birthdate']).to include(a_string_including('must be less than'))
      end

      it 'does not create a user' do
        expect { subject }.not_to change(User, :count)
      end
    end
  end
end
