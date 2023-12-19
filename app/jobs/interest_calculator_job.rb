class InterestCalculatorJob
  include Sidekiq::Worker

  def perform
    loans = Loan.open

    loans.each do |loan|
      user = loan.user
      interest_rate = loan.interest_rate || 5
      amount = loan.amount
      final_amount = amount + (interest_rate / 100 * amount)
      loan.update(amount: final_amount)

      if final_amount >= user.wallet_amount
        admin = Admin.first
        admin.update(wallet_amount: admin.wallet_amount + user.wallet_amount)
        user.update(wallet_amount: 0)
        loan.repay!
      end
    end
  end
end
