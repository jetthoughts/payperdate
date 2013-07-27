ActiveAdmin.register Profile do
  show title: -> p { "#{p.user.name}'s Profile" } do
  end
end
