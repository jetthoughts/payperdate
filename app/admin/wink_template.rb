ActiveAdmin.register WinkTemplate do
  config.filters = false
  actions :all, except: [:destroy]

  scope :enabled
  scope :disabled

  batch_action :disable do |selection|
    authorize! :disable, WinkTemplate
    WinkTemplate.find(selection).each do |wink_template|
      wink_template.disable!
    end
    redirect_to admin_wink_templates_path
  end

  batch_action :enable do |selection|
    authorize! :enable, WinkTemplate
    WinkTemplate.find(selection).each do |wink_template|
      wink_template.enable!
    end
    redirect_to admin_wink_templates_path
  end

  member_action :enable, method: :put do
    gift_template = WinkTemplate.find(params[:id])
    authorize! :enable, WinkTemplate
    gift_template.enable!
    redirect_to admin_wink_templates_path
  end

  member_action :disable, method: :put do
    gift_template = WinkTemplate.find(params[:id])
    authorize! :disable, WinkTemplate
    gift_template.disable!
    redirect_to admin_wink_templates_path
  end

  index title: 'Wink templates', download_links: false do
    selectable_column
    column :name
    column :image do |wt|
      link_to wt.image.url, class: :fancybox_popups do
        image_tag wt.image.url(:thumb)
      end
    end
    column :created_at
    column 'State actions' do |wink_template|
      render 'admin/wink_templates/state_actions', wink_template: wink_template
    end
    default_actions
  end

  form do |f|
    if f.object.new_record?
      f.inputs :image
    end
    f.inputs :name, :disabled
    f.actions
  end

  show do
    div class: "tab panel account" do
      h3 "Account"
      div class: "panel_contents" do
        attributes_table_for resource, *%w(id disabled created_at updated_at)  do
          row 'Image' do |wt|
            image_tag wt.image.url
          end
        end
      end
    end
  end
end