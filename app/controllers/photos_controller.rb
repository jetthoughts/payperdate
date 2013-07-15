#TODO: Add tests
class PhotosController < BaseController
  before_action :find_album
  load_and_authorize_resource except: [:create]
  before_filter :ensure_user_has_filled_profile


  def index
    @photos = page_owner? ? @album.photos : @album.photos.approved
  end

  def create
    @photo = @album.photos.create(photo_params)
    respond_with(@photo, layout: false)
  end

  def destroy
    @photo = @album.photos.find(params[:id])
    @photo.destroy
    respond_with(@photo)
  end

  private

  def photo_params
    params.require(:photo).permit(:image)
  end

  def find_album
    @album = selected_user.albums.find(params[:album_id])
  end
end