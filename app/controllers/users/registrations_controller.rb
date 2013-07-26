class Users::RegistrationsController < Devise::RegistrationsController
  def create
    if captcha_valid?
      super
    else
      self.resource = build_resource(sign_up_params)
      clean_up_passwords(resource)
      flash.now[:alert] = "There was an error with the recaptcha code below. Please re-enter the code."
      flash.delete :recaptcha_error
      render :new
    end
  end

  def after_sign_up_path_for(resource)
    root_path
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :name, :phone, :login, :nickname, :existent_email)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :name, :phone, :login, :nickname, :existent_email, :current_password, :password_confirmation)
  end

  private

  def captcha_valid?
    Rails.env.development? || Rails.env.test? || verify_recaptcha
  end

end
