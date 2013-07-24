#TODO: Move to Me::AvatarsController
class AvatarsController < BaseController
  after_filter :tracks_activity

  #FIXME: What is it? Why we cannot use default solution?
  def create
    @avatar         = Avatar.new(avatars_attributes)
    @avatar.profile = current_profile
    @avatar.save

    current_profile.reload
    render layout: false
  end

  #FIXME: What is it? Why we cannot use default solution?
  def destroy
    current_profile.avatar = nil
    current_profile.save
  end

  #TODO: Move to PhotosController
  def use
    photo                  = Photo.find(params[:id])
    @avatar                = photo.make_avatar
    current_profile.avatar = @avatar
    current_profile.save
    render nothing: true
  end

  private

  def avatars_attributes
    params.require(:avatar).permit(:image)
  end

  def tracks_activity
    current_user.activities.create! action: "#{action_name}_avatar", subject: current_profile
  end
end