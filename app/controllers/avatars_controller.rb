class AvatarsController < BaseController

  def create
    #current_profile.create_avatar(avatars_attributes)
    avatar = Avatar.new(avatars_attributes)
    avatar.profile = current_profile
    avatar.save
    current_profile.reload
    render layout: false
  end

  def destroy
    current_profile.avatar = nil
    current_profile.save
  end

  def use
    @avatar = Avatar.find(params[:id])
    current_profile.avatar = @avatar
    current_profile.save
    render nothing: true
  end

  private

  def avatars_attributes
    params.require(:avatar).permit(:image)
  end

end