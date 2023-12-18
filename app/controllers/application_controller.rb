class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      user_path(current_user)
    elsif resource.is_a?(Admin)
      admin_path(current_admin)
    else
      super
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path # Customize this line based on where you want users to be redirected after sign out
  end
end
