# app/models/loan.rb
class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :admin, optional: true

  include AASM

  # app/models/loan.rb
  validates :interest_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true

  after_initialize :set_default_interest_rate, if: :new_record?

  aasm column: 'state' do
    state :requested, initial: true
    state :approved
    state :open
    state :closed
    state :rejected

    event :approve do
      transitions from: :requested, to: :approved
    end

    event :reject_by_admin do
      transitions from: :requested, to: :rejected
    end

    event :confirm do
      transitions from: :approved, to: :open
    end

    event :reject_by_user do
      transitions from: :approved, to: :rejected
    end

    event :repay do
      transitions from: :open, to: :closed
    end
  end

  private

  def set_default_interest_rate
    self.interest_rate ||= 5
  end

  def calculate_interest_rate
    self.interest_rate = perform_calculate_interest_rate
  end

  def perform_calculate_interest_rate
    user_interest_rate = self.user&.interest_rate || 5
    loan_amount_factor = self.amount > 1000 ? 1.1 : 1.0
    calculated_interest_rate = user_interest_rate * loan_amount_factor

    [0, [calculated_interest_rate, 0.20].min].max
  end
end
