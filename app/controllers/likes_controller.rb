# frozen_string_literal: true

class LikesController < ApplicationController
  def create
    like = tweet.likes.new(user_id: current_user.id)

    if like.save
      render tweet
    else
      render tweet, status: :unprocessable_entity
    end
  end

  def destroy
    like = tweet.likes.where(user: current_user).find(params[:id])
    like.destroy
    render tweet
  end

  private

  def tweet
    @tweet ||= Tweet.includes(:user).find(params[:tweet_id])
  end
end
