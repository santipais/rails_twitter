# frozen_string_literal: true

module UsersHelper
  def profile_image(user)
    if user.profile_image.attached?
      user.profile_image
    else
      'profile.png'
    end
  end
end
