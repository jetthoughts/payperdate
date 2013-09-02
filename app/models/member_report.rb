class MemberReport < ActiveRecord::Base

  ALLOWED_CONTENT = %w(profile)

  belongs_to :user
  belongs_to :reported_user, class_name: 'User'
  belongs_to :content, polymorphic: true

  validates :user, :reported_user, :content, presence: true
  validates :message, presence: true, length: { maximum: 1000 }

  validate :has_allowed_content?
  validate :reported_user_is_content_owner?

  state_machine :state, initial: :active do
    before_transition active: :user_blocked do |member_report|
      user = member_report.reported_user
      user.block! if user.active?
      user.member_reports.update_all(state: 'user_blocked')
    end

    event :dismiss do
      transition active: :dismissed
    end

    event :block_reported_user do
      transition active: :user_blocked
    end
  end

  def self.all_states
    state_machines[:state].states.keys
  end

  all_states.each do |state_name|
    scope state_name, -> { where(state: state_name.to_s) }
  end

  private

  def has_allowed_content?
    errors.add(:base, :reporting_to_this_content_not_allowed) unless ALLOWED_CONTENT.include?(content.class.name.underscore)
  end

  def reported_user_is_content_owner?
    errors.add(:base, :content_is_not_owned_by_user) unless content && content.user_id == reported_user_id
  end

end
