ActiveAdmin.register Photo do
  filter :created_at
  # filter :album_user_id, as: :select, label: 'User', collection: -> { User.all.map { |u| ["#{u.name}(#{u.email})", u.id] } }.call
  scope :all, default: true
  scope :pending
  scope :approved
  scope :declined

  batch_action :approve do |selection|
    authorize! :approve, Photo

    Photo.find(selection).each do |photo|
      photo.approve!
    end
    redirect_to admin_photos_path
  end

  batch_action :decline do |selection|
    authorize! :decline, Photo

    Photo.find(selection).each do |photo|
      photo.decline!
    end
    redirect_to admin_photos_path
  end

  member_action :approve, method: :put do
    photo = Photo.find params[:id]
    authorize! :approve, Photo
    photo.approve!
    redirect_to [:admin, :photos]
  end

  member_action :decline, method: :put do
    photo = Photo.find params[:id]
    authorize! :decline, Photo
    photo.decline!(params[:reason] || :by_unknown)
    redirect_to [:admin, :photos]
  end

  index title: 'Photos', download_links: false do
    selectable_column

    column :user do |photo|
      link_to photo.user.name, [:admin, photo.user]
    end

    column :photo do |photo|
      link_to photo.image.url, class: :fancybox_popups do
        image_tag photo.image.url(:medium)
      end
    end

    column :photo_nudity_status do |photo|
      photo.nude?
    end

    column 'Approve Status' do |photo|
      render 'admin/photo/approve_status', photo: photo, resource: :photo
    end

    column 'Approve' do |photo|
      render 'admin/photo/approve_actions', photo: photo, resource: :photo
    end

    default_actions
  end

  controller do
    def scoped_collection
      Photo.not_avatars
    end
  end

end
