class Users::SessionsController < Devise::SessionsController
  after_filter :log_failed_login, only: :new

  private

  def log_failed_login
    if failed_login?
      login = request.filtered_parameters['user']['email']
      user  = User.find_for_database_authentication(email: login)
      user.failed_login! if user
    end
  end

  def failed_login?
    (options = env['warden.options']) && options[:action] == 'unauthenticated'
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def resource_params
    params.require(:user).permit(:email, :password, :login, :remember_me)
  end

end
