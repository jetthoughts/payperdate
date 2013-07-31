ActiveAdmin.register Gift do
  Gift.state_machines[:state].states.each do |state|
    scope state.name
  end

  batch_action :disable do |selection|
    authorize! :disable, Gift
    Gift.find(selection).each do |gift|
      gift.disable!
    end
    redirect_to admin_gifts_path
  end

  batch_action :enable do |selection|
    authorize! :enable, Gift
    Gift.find(selection).each do |gift|
      gift.enable!
    end
    redirect_to admin_gifts_path
  end

  member_action :enable, method: :put do
    gift = Gift.find(params[:id])
    authorize! :enable, Gift
    gift.enable
    redirect_to [:admin, :gifts]
  end

  member_action :disable, method: :put do
    gift = Gift.find(params[:id])
    authorize! :disable, Gift
    gift.disable
    redirect_to [:admin, :gifts]
  end

  index title: 'Gifts', download_links: false do
    selectable_column

    column :gift do |gift|
      link_to gift.image.url, class: :fancybox_popups do
        image_tag gift.image.url(:medium)
      end
    end

    column :state do |gift|
      gift.state
    end

    column 'State actions' do |photo|
      render 'admin/gift/state_actions', gift: photo
    end

    default_actions
  end

  form do |f|
    f.inputs 'Gift' do
      f.input :image, hint: f.template.image_tag(f.object.image.url(:medium))
    end
    f.actions
  end
end