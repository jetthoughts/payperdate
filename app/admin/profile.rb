ActiveAdmin.register Profile do
  show title: -> p { "#{p.user.name}'s Profile" } do
  end

  sidebar :notes, only: [:edit, :show] do
    render 'admin/profile_notes/list', profile: resource
  end
end
