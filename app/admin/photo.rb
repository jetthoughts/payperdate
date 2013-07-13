ActiveAdmin.register Photo do
  filter :created_at

  scope :pending, default: true
  scope :approved
  scope :declined

  batch_action :approve  do |selection|
    authorize! :approve, Photo
    Photo.find(selection).each do |photo|
      photo.approve!
    end
    redirect_to [:admin, :photos]
  end

  batch_action :decline  do |selection|
    authorize! :decline, Photo
    Photo.find(selection).each do |photo|
      photo.decline!
    end
    redirect_to [:admin, :photos]
  end

  index title: 'Photos', download_links: false do
    selectable_column
    column :user do |r|
      link_to r.user.name, [:admin, r.user]
    end

    column :photo do |r|
      link_to r.image.url, class: :fancybox_popups do
        image_tag r.image.url(:medium)
      end
    end
    default_actions
  end

end
