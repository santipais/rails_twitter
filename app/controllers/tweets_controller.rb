# frozen_string_literal: true

class TweetsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @tweets = Tweet.order(created_at: :desc)

    return if current_user.blank?

    @new_tweet = current_user.tweets.new
  end

  def new
    @tweet = current_user.tweets.new
  end

  def create
    @tweet = current_user.tweets.new(tweet_params)

    if @tweet.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content)
  end
end
