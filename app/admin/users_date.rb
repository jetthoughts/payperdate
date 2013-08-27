ActiveAdmin.register UsersDate do
  config.batch_actions = false
  config.clear_action_items!

  scope :unlocked
  scope :locked

  index do
    column :owner
    column :recipient
    column :unlocked do |users_date|
      users_date.unlocked.to_s
    end
    column 'Communication cost' do |users_date|
      users_date.communication_cost.cost
    end
    column 'Transaction' do |users_date|
      if users_date.transaction
        link_to users_date.transaction.action, admin_transaction_path(users_date.transaction)
      else
        'has no transaction'
      end
    end
    column :created_at
    default_actions
  end

end
