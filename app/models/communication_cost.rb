class CommunicationCost < ActiveRecord::Base
  monetize :start_amount_cents
  monetize :end_amount_cents

  def name
    "Communication Cost (#{start_amount}-#{end_amount} -> #{cost})"
  end

  def self.get(price)
    price = price.cents if price.respond_to? :cents
    where do
      (start_amount_cents <= price) & (end_amount_cents >= price) |
      (start_amount_cents <= price) & (end_amount_cents == 0    ) |
      (start_amount_cents == 0    ) & (end_amount_cents >= price)
    end.first
  end
end
