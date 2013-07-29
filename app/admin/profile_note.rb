ActiveAdmin.register ProfileNote do
  belongs_to :profile
  controller do
    layout false

    def create
      super do
        render @profile_note
        return
      end
    end
  end
end