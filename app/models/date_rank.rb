class DateRank < ActiveRecord::Base
  belongs_to :user
  belongs_to :users_date, inverse_of: :date_ranks
  belongs_to :courtesy_rank, class_name: 'Rank'
  belongs_to :punctuality_rank, class_name: 'Rank'
  belongs_to :authenticity_rank, class_name: 'Rank'

  validates :user, :users_date, :courtesy_rank, :punctuality_rank, :authenticity_rank, presence: true
  validate :validate_user_referenced_by_users_date

  private

  def validate_user_referenced_by_users_date
    self.errors.add(:user, :user_not_referenced_by_users_date) unless users_date.belongs_to?(user)
  end

end
