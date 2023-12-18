class InterestCalculatorJob
  include Sidekiq::Job

  def perform(loan_id)
    loan = Loan.find(loan_id)

    # Calculate interest based on custom logic
    interest_rate = loan.interest_rate || 0.05 # Default interest rate is 5%
    calculated_interest = loan.amount * interest_rate

    # Update loan state and interest amount
    loan.with_lock do
      loan.update!(interest_amount: calculated_interest)
      loan.confirm! if loan.requested? # Assuming you transition to 'confirm' state when interest is calculated
      end
    end
end
