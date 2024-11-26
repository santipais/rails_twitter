# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    private

    def sign_up_params
      params.require(resource_name)
            .permit(:name, :email, :username, :birthdate, :website, :bio, :first_name, :last_name)
    end
  end
end
