ActiveAdmin.register User do
  scope :all
  scope :active
  scope :blocked
  scope :abuse

  filter :email
  filter :name
  filter :nickname

  member_action :block, method: :put do
    user = User.find(params[:id])
    authorize! :block, User
    user.block!
    redirect_to [:admin, :users]
  end

  index do
    column :name
    column :email
    column :nickname
    column :abuse
    column :blocked
    column :actions do |user|
      render 'admin/user/customer_care_actions', user: user, resource: :user
    end
    default_actions
  end

  form do |f|
    f.inputs 'Admin Details' do
      f.input :email
      f.input :name
      f.input :nickname
      f.input :password
      f.input :password_confirmation
      f.input :abuse
      f.input :blocked
    end
    f.actions
  end
end
