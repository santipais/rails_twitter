# frozen_string_literal: true

class UserController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      respond_to do |format|
        format.turbo_stream do
          render(turbo_stream: turbo_stream.replace(
            'user_form',
            partial: 'form',
            locals: { user: @user }
          ))
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user)
          .permit(:first_name, :last_name, :bio, :website, :birthdate)
  end
end
