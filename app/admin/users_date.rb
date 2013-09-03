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
    column :created_at
    default_actions
  end

end
