class PhotosController < BaseController
  include ActionView::RecordIdentifier
  respond_to :html, :js
  before_action :find_album
  load_and_authorize_resource except: [:create]

  def index
    @photos = page_owner? ? @album.photos : @album.photos.approved
  end

  def create
    @photo = @album.photos.create(photo_attributes)
    respond_with(@photo, layout: false)
  end

  def destroy
    photo = @album.photos.find(params[:id])
    @photo_id = dom_id(photo)
    photo.destroy
    respond_with(@photo_id)
  end

  private

  def photo_attributes
    params.require(:photo).permit(:image)
  end

  def find_album
    @album = selected_user.albums.find(params[:album_id])
  end

end