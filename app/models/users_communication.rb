class UsersCommunication < ActiveRecord::Base

  belongs_to :owner, class_name: "User"
  belongs_to :recipient, class_name: "User"

  sifter :by_users do |user1, user2|
    (owner_id == user1.id) & (recipient_id == user2.id)
  end

  def self.find_by_users(user1, user2)
    where{ sift(:by_users, user1, user2) | sift(:by_users, user2, user1) }.first
  end

  def unlock
    update! unlocked: true
    
    transaction = ::Transaction.create key: 'unlock_communication',
      recipient: recipient,
      trackable: communication_cost,
      amount: -communication_cost.cost,
      owner: owner

    transaction.purchase
  end

  def communication_cost
    @communication_cost ||= CommunicationCost.get(invitation.amount)
  end

  def invitation
    @invitation ||= Invitation.find_by_users owner, recipient
  end
end
