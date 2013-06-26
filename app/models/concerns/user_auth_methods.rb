module UserAuthMethods
  def failed_login!
    self.failed_sign_in_count +=1
    save!
  end

  def has_fake_email?
    self.email.match(/dummy\.com$/).present?
  end

  def registration_incomplete?
    has_fake_email? || no_password?
  end

  def existent_email
    has_fake_email? ? '' : email
  end

  def existent_email=(new_value)
    self.email = new_value
  end

  def update_with_password(params, *options)
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = if no_password? || valid_password?(current_password)
               params['no_password'] = !params['password'].present? if no_password?
               update_attributes(params, *options)
             else
               self.assign_attributes(params, *options)
               self.valid?
               self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
               false
             end

    clean_up_passwords
    result
  end

end