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
    context 'when the tweet has images' do
      let(:images) { [fixture_file_upload(Rails.root.join('spec/support/assets/image.png'), 'image/png')] }
      let(:params) do
        {
          tweet: { content:, images: }
        }
      end
      it 'redirects to the root page' do
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
      end

      it 'creates the tweet' do
        expect { subject }.to change(user.reload.tweets, :count).from(0).to(1)
      end

      it 'sets the correct data' do
        subject

        expect(tweet.content).to eq(content)
        expect(tweet.user).to eq(user)
        expect(tweet.images).to be_attached
      end
    end

    context 'when the tweet does not have images' do
      it 'redirects to the root page' do
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
      end

      it 'creates the tweet' do
        expect { subject }.to change(user.reload.tweets, :count).from(0).to(1)
      end

      it 'sets the correct data' do
        subject

        expect(tweet.content).to eq(content)
        expect(tweet.user).to eq(user)
        expect(tweet.images).not_to be_attached
      end
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

    context 'when a image is invalid' do
      let(:params) do
        {
          tweet: { content:, images: }
        }
      end

      context 'when the image is too big' do
        let(:images) { [fixture_file_upload(Rails.root.join('spec/support/assets/big.png'), 'image/png')] }

        it 'returns an unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(user.tweets.last.errors['images']).to include('must be less than 1MB.')
        end

        it 'does not create a tweet' do
          expect { subject }.not_to change(Tweet, :count)
        end
      end

      context 'when the image is of an invalid type' do
        let(:images) { [fixture_file_upload(Rails.root.join('spec/support/assets/invalid.txt'), 'text/plain')] }

        it 'returns an unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(user.tweets.last.errors['images']).to include('must be of type: jpeg, png or gif.')
        end

        it 'does not create a tweet' do
          expect { subject }.not_to change(Tweet, :count)
        end
      end
    end
  end
end
