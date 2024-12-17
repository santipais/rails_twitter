# frozen_string_literal: true

class FollowsController < ApplicationController
  before_action :authenticate_user!, :set_user

  def create
    follow = current_user.follows.new(followed: @user)

    if follow.save
      render '_follow', locals: { user: @user, following_user: true }
    else
      redirect_to user_path(@user), status: :unprocessable_entity
    end
  end

  def destroy
    follow = current_user.follows.find_by!(followed: @user)
    follow.destroy
    render '_follow', locals: { user: @user, following_user: false }
  end

  private

  def set_user
    @user = User.find_by!(username: params[:user_id])
  end
end
