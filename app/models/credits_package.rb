class CreditsPackage < ActiveRecord::Base

  monetize :price_cents, numericality: { greater_than_or_equal_to: 0}
  validates :credits, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  def to_s
    "%d credits for %.2f %s" % [credits, price, price_currency]
  end

end
