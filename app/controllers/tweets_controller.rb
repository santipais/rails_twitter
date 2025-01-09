# frozen_string_literal: true

class TweetsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    tweets = Tweet.includes(:likes, :likers, user: { profile_image_attachment: :blob }).feed(current_user).with_attached_images.order(created_at: :desc)
    @pagy, @tweets = pagy_countless(tweets, limit: 5)
    pagy_headers_merge(@pagy)
    @new_tweet = current_user.tweets.new if current_user.present?

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @tweet = current_user.tweets.new
  end

  def create
    @tweet = current_user.tweets.new(tweet_params)

    if @tweet.save
      respond_to do |format|
        format.html { redirect_to root_path }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('new_tweet', partial: 'tweets/form', locals: { new_tweet: current_user.tweets.new })
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def search
    @first_search = first_search?
    @q = search_params[:q]
    @following = ActiveModel::Type::Boolean.new.cast(search_params[:following])
    @pagy, @tweets = pagy_countless(filtered_tweets.order(created_at: :desc), limit: 5)

    respond_to do |format|
      format.html { render :search }
      format.turbo_stream { render :search }
    end
  end

  private

  def filtered_tweets
    tweets = Tweet.excluding(current_user.tweets)
    tweets = tweets.search_tweets(@q) if @q.present?
    tweets = tweets.where(user: current_user.following_users) if @following && current_user.present?

    tweets.includes(:likes, :likers, user: { profile_image_attachment: :blob }).with_attached_images
  end

  def tweet_params
    params.require(:tweet).permit(:content, images: [])
  end

  def search_params
    params.permit(:q, :following, :page)
  end

  def first_search?
    search_params[:page].blank?
  end
end
