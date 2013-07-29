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
    column :blocked
    column :actions do |user|
      render 'admin/user/customer_care_actions', user: user, resource: :user
    end
    column do |user|
      link_to 'Profile', edit_admin_profile_path(user.profile)
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
      f.input :blocked
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
