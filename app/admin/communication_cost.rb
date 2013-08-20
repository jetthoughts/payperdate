ActiveAdmin.register CommunicationCost do

  index do
    selectable_column
    column :id
    column :start_amount do |communication_cost|
      humanized_money_with_symbol communication_cost.start_amount
    end
    column :end_amount do |communication_cost|
      humanized_money_with_symbol communication_cost.end_amount
    end
    column :cost do |communication_cost|
      pluralize(communication_cost.cost, 'credit')
    end
    column :created_at
    column :updated_at
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :start_amount
      f.input :end_amount
      f.input :cost
    end
    f.actions
  end

  show do |communication_cost|
    attributes_table do
      row :id
      row :start_amount do
        humanized_money_with_symbol communication_cost.start_amount
      end
      row :end_amount do
        humanized_money_with_symbol communication_cost.end_amount
      end
      row :cost do
        pluralize(communication_cost.cost, 'credit')
      end
      row :created_at
      row :updated_at
    end
  end

end
