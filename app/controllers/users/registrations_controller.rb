class Users::RegistrationsController < Devise::RegistrationsController
  def create
    if verify_recaptcha
      super
    else
      build_resource
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
    params.require(:user).permit(:email, :password, :name, :phone, :login)
  end

end
