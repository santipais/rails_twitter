# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    private

    def sign_up_params
      params.require(resource_name)
            .permit(:name, :email, :password, :password_confirmation, :username)
    end
  end
end
