ActiveAdmin.register Transaction do
  config.batch_actions = false
  config.clear_action_items!

  filter :trackable_type
  filter :owner, collection: User.all
  filter :recipient, collection: User.all
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
    column "Action" do |transaction|
      I18n.t("credit_transaction.keys.#{transaction.key}",
             name: transaction.trackable.to_s,
             username: transaction.owner.name,
             amount: transaction.amount)
    end
    column :state
    column :created_at
  end

end
