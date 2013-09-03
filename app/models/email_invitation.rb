class EmailInvitation < ActiveRecord::Base
  belongs_to :user, inverse_of: :email_invitations

  validates :user, :email, presence: true
  validate :validate_user_already_registered

  after_create :send_invitation_email

  private

  def validate_user_already_registered
    self.errors.add(:email, :user_already_registered) if User.find_by_email(email)
  end

  def send_invitation_email
    EmailInvitationMailer.delay.invite_by_email(self.id)
  end

end
