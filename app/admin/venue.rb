ActiveAdmin.register Venue do
  filter :name
  index title: 'Venues' do
    column :name
    column :rating
    column :url
    column :address
    column :location
    column :phones
    default_actions
  end
end