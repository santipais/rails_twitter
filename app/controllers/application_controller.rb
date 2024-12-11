# frozen_string_literal: true

class ApplicationController < ActionController::Base
  respond_to :html, :json
  helper_method :current_user?

  private

  def current_user?(user)
    current_user == user
  end
end
