# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @tweet = Tweet.includes(:user).find(params[:tweet_id])
    like = @tweet.likes.new(user: current_user)
    if like.save
      render @tweet
    else
      render @tweet, status: :unprocessable_entity
    end
  end

  def destroy
    like = Like.find(params[:id])
    @tweet = like.tweet
    like.destroy!
    render @tweet
  end
end
