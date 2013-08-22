class Users::PasswordsController < Devise::PasswordsController
  # pulled from original devise code
  # and patched to not sign_in if state is not active
  # and deleted_state is not none
  # and to restrict password reset for deleted users at all

  # POST /resource/password
  def create
    found = resource_class.find_for_database_authentication(resource_params)
    if !found || found.deleted_state == 'none'
      self.resource = resource_class.send_reset_password_instructions(resource_params)

      if successfully_sent?(resource)
        respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
      else
        respond_with(resource)
      end
    else
      puts 'bga'
      set_flash_message(:alert, :deleted)
      respond_with found, location: new_user_password_path
    end
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      # here goes change
      sign_in(resource_name, resource) if resource.active? and resource.deleted_state == 'none'
      respond_with resource, :location => after_resetting_password_path_for(resource)
    else
      respond_with resource
    end
  end
end
