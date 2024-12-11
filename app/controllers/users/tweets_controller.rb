# frozen_string_literal: true

module Users
  class TweetsController < ApplicationController
    before_action :set_user

    def index
      @tweets = Tweet.where(user: @user).order(created_at: :desc).includes(:user)
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
