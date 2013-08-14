ActiveAdmin.register User do
  scope :all
  scope :active
  scope :blocked

  filter :email
  filter :name
  filter :nickname

  member_action :block, method: :put do
    user = User.find(params[:id])
    block_user user
    redirect_to [:admin, :users]
  end

  batch_action :block do |selection|
    User.find(selection).each { |user| block_user(user) }
    redirect_to [:admin, :users]
  end

  member_action :unblock, method: :put do
    user = User.find(params[:id])
    authorize! :block, User
    user.unblock!
    redirect_to [:admin, :users]
  end

  batch_action :unblock do |selection|
    authorize! :block, User
    User.find(selection).each { |user| user.unblock! }
    redirect_to [:admin, :users]
  end

  member_action :delete, method: :delete do
    user = User.find(params[:id])
    authorize! :delete, User
    user.delete_account!
    redirect_to [:admin, :users]
  end

  batch_action :delete_account do |selection|
    authorize! :delete, User
    User.find(selection).each { |user| user.delete_account! }
    redirect_to [:admin, :users]
  end

  member_action :login, title: 'Login As' do
    authorize! :login, resource
    sign_in('user', resource)
    redirect_to user_profile_path(resource)
  end

  index do
    selectable_column
    column :name
    column :email
    column :nickname
    column :state
    column 'actions' do |user|
      span do
        link_to 'Profile', admin_profile_path(user.published_profile)
      end
      span do
        link_to 'View', admin_user_path(user)
      end
      span do
        link_to 'Edit', edit_admin_user_path(user)
      end
      span do
        render 'admin/user/customer_care_actions', user: user, resource: :user
      end
    end
    # default_actions
  end

  form do |f|
    f.inputs 'Admin Details' do
      f.input :email
      f.input :name
      f.input :nickname
      f.input :password
      f.input :password_confirmation
      f.input :state, as: :select, collection: f.object.class.state_machines[:state].states.keys, include_blank: false
    end
    f.actions
  end

  sidebar 'User Details', only: [:show] do
    ul do
      li link_to('Activities', admin_user_activities_path(resource))
    end
  end

  controller do

    private

    def block_user user
      authorize! :block, User
      user.block!
      sign_out(user)
    end
  end

end
