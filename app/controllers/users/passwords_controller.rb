class Users::PasswordsController < Devise::PasswordsController
  # pulled from original devise code
  # and patched to not sign_in if state is not active
  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      # here goes change
      sign_in(resource_name, resource) if resource.active?
      respond_with resource, :location => after_resetting_password_path_for(resource)
    else
      respond_with resource
    end
  end
end
