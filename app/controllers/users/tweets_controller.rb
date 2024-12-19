# frozen_string_literal: true

module Users
  class TweetsController < ApplicationController
    before_action :set_user
    skip_before_action :authenticate_user!

    def index
      @tweets = @user.tweets.includes(:likers).order(created_at: :desc)
      render partial: 'tweets', locals: { tweets: @tweets }
    end

    private

    def set_user
      @user = User.find_by!(username: params[:user_id])
    end

    def tweet_params
      params.require(:tweet).permit(:content)
    end
  end
end
