ActiveAdmin.register Wink do
  filter :created_at
  filter :user
  filter :recipient

  config.batch_actions = false
  actions :all, except: [:new, :edit, :update, :destroy]

  index title: 'Winks', download_links: false do

    column :image do |wt|
      link_to wt.image.url, class: :fancybox_popups do
        image_tag wt.image.url(:thumb)
      end
    end
    column 'Sender', :user
    column :recipient
    column :created_at
    default_actions
  end

end
