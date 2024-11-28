# frozen_string_literal: true

class UserController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to @user
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

  def user_params
    params.require(:user)
          .permit(:first_name, :last_name, :bio, :website, :birthdate)
  end
end
