ActiveAdmin.register CreditsPackage do
  index do
    selectable_column
    column :id
    column :price do |credits_package|
      humanized_money_with_symbol credits_package.price
    end
    column :credits do |credits_package|
      pluralize(credits_package.credits, 'credit')
    end
    column :description
    column :created_at
    column :updated_at
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :price
      f.input :credits
      f.input :description
    end
    f.actions
  end

  show do |credits_package|
    attributes_table do
      row :id
      row :price do |credits_package|
        humanized_money_with_symbol credits_package.price
      end
      row :credits do |credits_package|
        pluralize(credits_package.credits, 'credit')
      end
      row :description
      row :created_at
      row :updated_at
    end
  end
end
