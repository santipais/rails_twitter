# frozen_string_literal: true

module Users
  class ConfirmationsController < Devise::ConfirmationsController
    def show
      with_unconfirmed_confirmable do
        if @confirmable.no_password?
          do_show
        else
          do_confirm
        end
      end
      return if @confirmable.errors.empty?

      self.resource = @confirmable
      render 'devise/confirmations/new'
    end

    def update
      with_unconfirmed_confirmable do
        if @confirmable.no_password?
          @confirmable.update(password_params)
          return do_confirm if @confirmable.valid? && @confirmable.password_match?

          return do_show

        else

          @confirmable.errors.add(:email, :password_already_set)
        end
      end

      return if @confirmable.errors.empty?

      self.resource = @confirmable
      render 'devise/confirmations/new'
    end

    protected

    def with_unconfirmed_confirmable(&)
      @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
      return if @confirmable.new_record?

      @confirmable.send(:pending_any_confirmation, &)
    end

    def do_show
      @confirmation_token = params[:confirmation_token]
      @requires_password = true
      self.resource = @confirmable
      if @confirmable.errors.any?
        render 'devise/confirmations/show', status: :unprocessable_entity, formats: [:html]
      else
        render 'devise/confirmations/show'
      end
    end

    def do_confirm
      @confirmable.confirm
      set_flash_message :notice, :confirmed
      sign_in_and_redirect(resource_name, @confirmable)
    end

    private

    def password_params
      params.require(:user)
            .permit(:password, :password_confirmation)
    end
  end
end
