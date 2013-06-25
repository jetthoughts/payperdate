class Users::SessionsController < Devise::SessionsController

  def resource_params
    puts '*'*100
    params.permit(user: [:email, :password, :login, :remember_me])
  end

  private

  def after_sign_in_path_for(resource)
    root_path
  end

end
