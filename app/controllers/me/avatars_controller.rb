class Me::AvatarsController < BaseController
  layout false
  default_profile_activity_tracking

  def create
    @avatar = current_user.create_avatar(avatars_attributes)
  end

  def destroy
    current_user.update_attributes avatar: nil
  end

  private

  def avatars_attributes
    params.require(:avatar).permit(:image)
  end
end
