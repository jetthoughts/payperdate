class AlbumsController < BaseController
  before_filter :ensure_user_has_filled_profile
  respond_to :js, :html
  load_and_authorize_resource except: [:create]

  def index
    @albums = selected_user.albums
  end

  def create
    @album  = current_user.albums.create(albums_attributes)
    respond_with(@album)
  end

  def edit
    @album = current_user.albums.find(params[:id])
  end

  def update
    @album = current_user.albums.find(params[:id])
    if @album.update_attributes(albums_attributes)
      redirect_to albums_path
    else
      render :edit
    end
  end

  def destroy
    album = current_user.albums.find(params[:id])
    #FIXME: Remove this logic from controller
    @album_id = dom_id(album)
    album.destroy
    respond_with(@album_id)
  end

  private

  def albums_attributes
    params.require(:album).permit(:name)
  end
end