ActiveAdmin.register ProfileNote do
  belongs_to :profile

  controller do
    layout false
  end
end