ActiveAdmin.register Service do
  menu label: "Spending credits"
  actions :index, :update, :edit
  config.batch_actions = false


  index title: "Spending credits" do
    selectable_column

    column :name
    column :cost do |service|
      number_to_currency(service.cost)
    end

    column :use_credits
    
    default_actions
  end

  form do |f|
    f.inputs "Service params" do
      f.input :name, input_html: { disabled: true }
      f.input :cost
      f.input :use_credits
    end
    f.actions
  end
end
