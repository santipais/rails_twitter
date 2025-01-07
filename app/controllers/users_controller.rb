# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @user = User.includes(:followers_users).with_attached_profile_image.find_by!(username: params[:id])
    @following_user = current_user.present? && @user.followers_users.include?(current_user)
  end
end
