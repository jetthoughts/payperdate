class Service < ActiveRecord::Base
  def self.get(service_key)
    find_by(key: service_key.to_s, use_credits: true)
  end

  def self.get_price(service_key)
    service = get(service_key)
    service.cost.to_f if service
  end
end
