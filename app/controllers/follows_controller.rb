# frozen_string_literal: true

class FollowsController < ApplicationController
  before_action :authenticate_user!, :set_user

  def create
    follow = current_user.follows.new(followed: @user)

    if follow.save
      respond_to do |format|
        format.html { redirect_to user_path(@user) }
        format.turbo_stream { render 'follow_update', locals: { user: @user, following_user: true } }
      end
    else
      redirect_to user_path(@user), status: :unprocessable_entity
    end
  end

  def destroy
    follow = current_user.follows.find_by!(followed: @user)
    follow.destroy
    @user.reload
    respond_to do |format|
      format.html { redirect_to user_path(@user) }
      format.turbo_stream { render 'follow_update', locals: { user: @user, following_user: false } }
    end
  end

  private

  def set_user
    @user = User.find_by!(username: params[:user_id])
  end
end
