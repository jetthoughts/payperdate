ActiveAdmin.register User do
  filter :email
  filter :name
  filter :nickname

  index do
    column :name
    column :email
    column :nickname
    default_actions
  end

  form do |f|
    f.inputs 'Admin Details' do
      f.input :email
      f.input :name
      f.input :nickname
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end