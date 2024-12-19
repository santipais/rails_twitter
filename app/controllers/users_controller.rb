# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.includes(:followers_users).find_by!(username: params[:id])
    @following_user = current_user.present? && @user.followers_users.include?(current_user)
  end
end
