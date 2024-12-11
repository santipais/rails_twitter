# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params[:id])
  end
end
