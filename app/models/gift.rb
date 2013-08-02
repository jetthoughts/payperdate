class Gift < ActiveRecord::Base
  require 'payperdate/file_size_validator'
  validates :image, presence: true, file_size: { maximum: 5.megabytes.to_i }

  mount_uploader :image, GiftUploader

  state_machine :state, initial: :enabled do
    event :enable do
      transition all => :enabled
    end

    event :disable do
      transition all => :disabled
    end
  end

  def self.all_states
    state_machines[:state].states
  end

  all_states.each do |state|
    scope state.name, -> { where(state: state.name) }
  end
end