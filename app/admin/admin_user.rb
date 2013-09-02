ActiveAdmin.register AdminUser do
  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email

  form do |f|
    f.inputs 'Admin Details' do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.inputs 'Permissions' do
      AdminUser.available_permissions.each do |permission|
        f.input permission, as: :boolean, label: I18n.t("admin.permissions.#{permission}")
      end
    end
    f.actions
  end

  show do |admin|
    attributes_table do
      rows :id, :email, :sign_in_count, :current_sign_in_at, :last_sign_in_at,
           :current_sign_in_ip, :last_sign_in_ip, :created_at, :updated_at
    end

    panel 'Permissions' do
      if admin.get_permissions.count == 0
        em I18n.t 'admin.permissions.no_permissions'
      end
      attributes_table_for admin do
        admin.get_permissions.each do |k, v|
          row k do
            I18n.t("admin.permissions.#{v ? :allowed : :denied}")
          end
        end
      end
    end
  end

  controller do
    before_filter :set_skip_password_validation, only: :update

    private

    def set_skip_password_validation
      @admin_user ||= AdminUser.find(params[:id])
      @admin_user.skip_password_validation = true
    end
  end

end
