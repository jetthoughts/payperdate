ActiveAdmin.register Transaction do
  config.batch_actions = false
  config.clear_action_items!

  filter :trackable_type
  # filter :owner, collection: User.all
  # filter :recipient, collection: User.all
  filter :amount_cents
  filter :key
  filter :created_at

  index do
    column :id
    column :trackable
    column :owner
    column :recipient
    column :amount do |transaction|
      pluralize transaction.amount, "credit"
    end
    column :action
    column :state
    column :created_at
  end


end
