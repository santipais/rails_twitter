# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tweets', type: :request do
  describe 'POST /tweets' do
    let!(:user) { build(:user) }
    let(:content) { Faker::String.random(length: 1..280) }
    let(:json) { response.parsed_body }
    let(:params) do
      {
        tweet: { content: }
      }
    end

    before { sign_in user }

    subject { post tweets_path, params: }

    context 'when the params are correct' do
      it 'redirects to the user show page' do
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(user_path)
      end

      it 'creates the tweet' do
        expect { subject }.to change(Tweet, :count).from(0).to(1)
        expect(content).to eq(user.tweets.last.content)
      end
    end

    context 'when the params are incorrect' do
      context 'when content is missing' do
        let(:content) { nil }

        it 'returns an unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(user.tweets.last.errors['content']).to include("can't be blank")
        end

        it 'does not create a tweet' do
          expect { subject }.not_to change(Tweet, :count)
        end
      end
    end
  end
end
