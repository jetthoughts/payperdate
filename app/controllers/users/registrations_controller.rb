class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :check_if_user_deleted, only: :create
  after_filter :track_delete_activity, only: :destroy

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

  def destroy
    @user = current_user
    current_user.delete!
    sign_out current_user
    redirect_to root_path
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

  def check_if_user_deleted
    user = User.find_by_login(sign_up_params[:email])
    if user && user.deleted?
      flash[:alert] = I18n.t 'devise.registrations.deleted_contact_support'
      redirect_to root_path
    end
  end

  def track_delete_activity
    @user.track_user_delete
  end

end
