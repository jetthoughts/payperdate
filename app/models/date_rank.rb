class DateRank < ActiveRecord::Base
  belongs_to :user
  belongs_to :invitation
  belongs_to :courtesy_rank, class_name: 'Rank'
  belongs_to :punctuality_rank, class_name: 'Rank'
  belongs_to :authenticity_rank, class_name: 'Rank'

  validates :user, :invitation, :courtesy_rank, :punctuality_rank, :authenticity_rank, presence: true
  validate :validate_invitation_accepted
  validate :validate_user_referenced_by_invitation

  private

  def validate_invitation_accepted
    self.errors.add(:invitation, :cant_rank_unaccepted_invitation) unless invitation.accepted?
  end

  def validate_user_referenced_by_invitation
    self.errors.add(:user, :user_not_referenced_by_invitation) unless invitation.belongs_to_user?(user)
  end

end
