class Service < ActiveRecord::Base
  monetize :cost_cents, numericality: { greater_than_or_equal_to: 0 }
end
