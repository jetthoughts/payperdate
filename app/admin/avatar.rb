ActiveAdmin.register Avatar do
  scope :all, :avatars, default: true
  scope :pending
  scope :approved
  scope :declined

  batch_action :approve do |selection|
    authorize! :approve, Photo

    Avatar.find(selection).each do |photo|
      photo.approve!
    end
    redirect_to [:admin, :avatars]
  end

  batch_action :decline do |selection|
    authorize! :decline, Photo

    Avatar.find(selection).each do |photo|
      photo.decline!
    end
    redirect_to [:admin, :avatars]
  end

  member_action :approve, method: :put do
    photo = Avatar.find params[:id]
    authorize! :approve, Photo
    photo.approve!
    redirect_to [:admin, :avatars]
  end

  member_action :decline, method: :put do
    photo = Avatar.find params[:id]
    authorize! :decline, Photo
    photo.decline!(params[:reason] || :by_unknown)
    redirect_to [:admin, :avatars]
  end

  index title: 'Avatars', download_links: false do
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

    column :photo_face_status do |photo|
      photo.face.nil? ? 'Have not been validated' : photo.face?
    end

    column 'Approve Status' do |photo|
      render 'admin/photo/approve_status', photo: photo, resource: :avatar
    end

    column 'Approve' do |photo|
      render 'admin/photo/approve_actions', photo: photo, resource: :avatar
    end

    default_actions
  end
end
