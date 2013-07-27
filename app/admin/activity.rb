ActiveAdmin.register Activity do
  belongs_to :user
  navigation_menu :user

  index download_links: false do
    column :subject
    column :action  do |a|
      I18n.t "admin.user.activities.action.#{a.action}"
    end

    column :details do |a|
      I18n.t "admin.user.activities.#{a.action}.details", (a.details || {}).with_indifferent_access
    end

    column :created_at
  end
end
