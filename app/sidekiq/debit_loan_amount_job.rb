class DebitLoanAmountJob
  include Sidekiq::Job

  def perform(loan_id)
    loan = Loan.find(loan_id)
    user = loan.user

    # Calculate total loan amount (principal + interest)
    total_loan_amount = loan.amount + loan.interest_amount

    if user.wallet_amount >= total_loan_amount
      # Sufficient funds in user's wallet, deduct the total amount
      user.debit_wallet(total_loan_amount)
      loan.close! # Assuming you transition to 'closed' state when the loan is repaid
    else
      # Insufficient funds, transfer whatever is in the user's wallet to admin
      amount_to_transfer = user.wallet_amount
      user.debit_wallet(amount_to_transfer)
      Admin.credit_wallet(amount_to_transfer)
      loan.close!
    end
  end
end
