# frozen_string_literal: true

class TweetsController < ApplicationController
  before_action :authenticate_user!

  def new
    @tweet = current_user.tweets.new
  end

  def create
    @tweet = current_user.tweets.new(tweet_params)

    if @tweet.save
      redirect_to user_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content)
  end
end
