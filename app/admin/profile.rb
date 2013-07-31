ActiveAdmin.register Profile do

  sidebar :notes, only: [:edit] do
    render 'admin/profile_notes/list', profile: resource
  end

  controller do
    def show

      redirect_to edit_admin_profile_path(resource)
    end
  end
end
