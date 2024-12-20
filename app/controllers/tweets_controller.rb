# frozen_string_literal: true

class TweetsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @tweets = Tweet.includes(:user, :likes, :likers).feed(current_user).order(created_at: :desc)

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
