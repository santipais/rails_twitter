# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /tweets', type: :request do
  let!(:user) { create(:user) }
  let(:content) { Faker::Lorem.characters(number: 1..280) }
  let(:tweet) { Tweet.last }
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
      expect { subject }.to change(user.reload.tweets, :count).from(0).to(1)
    end

    it 'sets the correct data' do
      subject

      expect(tweet.content).to eq(content)
      expect(tweet.user).to eq(user)
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
