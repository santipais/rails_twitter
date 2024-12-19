# frozen_string_literal: true

class FollowsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_user

  def index
    @follow_users = follow_users.select("users.*,
        EXISTS (
          SELECT 1
          FROM follows
          WHERE follows.user_id = #{current_user&.id.presence || 'NULL'}
          AND follows.followed_id = users.id
        ) AS followed_by_current_user")
  end

  def create
    follow = current_user.follows.new(followed: @user)

    if follow.save
      render partial: 'users/follow', locals: { user: @user, following_user: true }
    else
      redirect_to user_path(@user), status: :unprocessable_entity
    end
  end

  def destroy
    follow = current_user.follows.find_by!(followed: @user)
    follow.destroy
    render partial: 'users/follow', locals: { user: @user, following_user: false }
  end

  private

  def set_user
    @user = User.find_by!(username: params[:user_id])
  end

  def follow_users
    if params[:followers] == 'true'
      @user.followers_users
    else
      @user.following_users
    end
  end
end
