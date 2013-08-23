class AlbumsController < BaseController
  before_filter :ensure_user_has_filled_profile
  before_action :setup_album, only: [:edit, :update, :destroy]
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
  end

  def update
    if @album.update_attributes(albums_attributes)
      redirect_to albums_path
    else
      render :edit
    end
  end

  def destroy
    @album.destroy
    render formats: [:js]
  end

  private

  def albums_attributes
    params.require(:album).permit(:name)
  end

  def setup_album
    @album = current_user.albums.find(params[:id])
  end
end
