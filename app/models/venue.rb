class Venue < ActiveRecord::Base
  scope :geocoded, -> { where{{ location.not_eq => nil }} }
  def search_for_location!
    if address && location.blank?
      self.location = Geocoder.coordinates(address)
      save
    end
  end

  def phone
    phones.first
  end

end
