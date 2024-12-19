# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  respond_to :html, :json
  helper_method :current_user?

  private

  def current_user?(user)
    current_user == user
  end
end
