ActiveAdmin.register GiftTemplate do
  GiftTemplate.state_machines[:state].states.each do |state|
    scope state.name
  end

  batch_action :disable do |selection|
    authorize! :disable, GiftTemplate
    GiftTemplate.find(selection).each do |gift_template|
      gift_template.disable!
    end
    redirect_to admin_gift_templates_path
  end

  batch_action :enable do |selection|
    authorize! :enable, GiftTemplate
    GiftTemplate.find(selection).each do |gift_template|
      gift_template.enable!
    end
    redirect_to admin_gift_templates_path
  end

  member_action :enable, method: :put do
    gift_template = GiftTemplate.find(params[:id])
    authorize! :enable, GiftTemplate
    gift_template.enable
    redirect_to [:admin, :gift_templates]
  end

  member_action :disable, method: :put do
    gift_template = GiftTemplate.find(params[:id])
    authorize! :disable, GiftTemplate
    gift_template.disable
    redirect_to [:admin, :gift_templates]
  end

  index title: 'Gift templates', download_links: false do
    selectable_column

    column :gift_template do |gift_template|
      link_to gift_template.image.url, class: :fancybox_popups do
        image_tag gift_template.image.url(:medium)
      end
    end

    column :state do |gift_template|
      gift_template.state
    end

    column 'State actions' do |gift_template|
      render 'admin/gift_template/state_actions', gift_template: gift_template
    end

    default_actions
  end

  form do |f|
    f.inputs 'Gift template' do
      f.input :image, hint: f.template.image_tag(f.object.image.url(:medium))
    end
    f.actions
  end
end