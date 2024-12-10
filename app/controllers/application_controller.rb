# frozen_string_literal: true

class ApplicationController < ActionController::Base
  respond_to :html, :json

  private

  def current_user?(user)
    current_user == user
  end

  helper_method :current_user?
end
