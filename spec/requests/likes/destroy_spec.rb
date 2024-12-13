# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /likes/:id', type: :request do
  let!(:user) { create(:user) }
  let!(:like) { create(:like, user: user) }
  let(:like_id) { like.id }

  before { sign_in user }

  subject { delete like_path(like_id) }

  context 'when the params are correct' do
    it 'returns a succsseful response' do
      subject
      expect(response).to have_http_status(:successful)
    end

    it 'deletes the like' do
      expect { subject }.to change(Like, :count).from(1).to(0)
    end
  end

  context 'when the params are incorrect' do
    let(:like_id) { 'invalid_id' }

    it 'returns a not found response' do
      expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
