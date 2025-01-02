# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :authenticate_user!

  respond_to :html, :json
  helper_method :current_user?

  private

  def current_user?(user)
    current_user == user
  end
end
