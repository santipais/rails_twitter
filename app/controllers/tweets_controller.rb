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
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def search
    @first_search = params[:page].blank?
    @q = params[:q]
    @following = params[:following]
    tweets = filtered_tweets
    @pagy, @tweets = pagy_countless(tweets, limit: 5)
    respond_to do |format|
      format.html { render :search }
      format.turbo_stream { render :search }
    end
  end

  private

  def filtered_tweets
    base_query = Tweet.includes(:likes, :likers, user: { profile_image_attachment: :blob })
                      .where('content LIKE ?', "%#{params[:q]}%").excluding(current_user.tweets)
    params[:following] == 'true' ? base_query.where(user_id: current_user.following_users) : base_query
  end

  def tweet_params
    params.require(:tweet).permit(:content, images: [])
  end
end
