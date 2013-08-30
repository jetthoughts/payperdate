class UsersDate < ActiveRecord::Base

  belongs_to :owner, class_name: "User"
  belongs_to :recipient, class_name: "User"
  has_many :date_ranks, inverse_of: :users_date
  has_one :transaction, inverse_of: :trackable, as: :trackable

  sifter :by_users do |user1, user2|
    (owner_id == user1.id) & (recipient_id == user2.id)
  end

  scope :by, -> (user) { where { (owner_id == user) | (recipient_id == user) } }
  scope :locked, -> { where(unlocked: false) }
  scope :unlocked, -> { where(unlocked: true) }

  def self.find_by_users(user1, user2)
    where{ sift(:by_users, user1, user2) | sift(:by_users, user2, user1) }.first
  end

  validate :validate_create_if_exists


  def belongs_to?(user)
    owner == user || recipient == user
  end

  def unlock
    if owner.credits_amount < communication_cost.cost
      errors.add(:base, :cant_unlocked_users_date)
    else
      update! unlocked: true

      transaction = ::Transaction.create key: 'unlock_communication',
        recipient: recipient,
        trackable: self,
        amount: -communication_cost.cost,
        owner: owner

      transaction.purchase
    end
    errors.any?
  end

  def communication_cost
    @communication_cost ||= CommunicationCost.get(invitation.amount)
  end

  def invitation
    @invitation ||= Invitation.accepted.find_by_users owner, recipient
  end

  def rank_by(u)
    date_ranks.where(user_id: u).first
  end

  def ranked?(u)
    rank_by(u) != nil
  end

  def can_be_communicated?(from, to)
    belongs_to?(from) && belongs_to?(to) && (recipient == from || unlocked?)
  end

  def can_be_unlocked_by?(u)
    owner == u && !unlocked?
  end

  def can_be_ranked?(u)
    unlocked? && belongs_to?(u) && !ranked?(u)
  end

  def can_view_rank?(u)
    belongs_to?(u) && ranked?(u)
  end

  def to_s
    "Date (#{owner.name} -> #{recipient.name})"
  end

  def partner(user)
    user == owner ? recipient : owner
  end

  private

  def validate_create_if_exists
    date = UsersDate.find_by_users(owner, recipient)
    errors.add(:base, :date_with_these_members_already_exists) if date && date != self
  end

end
