class PhotosController < BaseController
  before_action :find_album
  load_and_authorize_resource except: [:create]
  before_filter :ensure_user_has_filled_profile

  before_filter :setup_photo, only: [:destroy, :use_as_avatar]

  default_profile_activity_tracking except: [:index]

  def index
    @photos = page_owner? ? @album.photos : @album.photos.approved
  end

  def create
    @photo = @album.photos.create(photo_params)
    respond_with(@photo, layout: false)
  end

  def destroy
    @photo.destroy
    respond_with(@photo)
  end

  def use_as_avatar
    current_user.update_attributes avatar: @photo.make_avatar
    render nothing: true
  end

  private

  def photo_params
    params.require(:photo).permit(:image)
  end

  def find_album
    @album = selected_user.albums.find(params[:album_id])
  end

  def setup_photo
    @photo = @album.photos.find(params[:id] || params[:photo_id])
  end
end
