class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      user_path(current_user)
    elsif resource.is_a?(Admin)
      admin_path(current_admin)
    else
      super
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path # Customize this line based on where you want users to be redirected after sign out
  end

  def wallet_logic(str, loan_id)
    loan = Loan.find_by(id: loan_id)
    loan_amount = loan.amount
    user_wallet = current_user.wallet_amount
    admin_wallet = Admin.first.wallet_amount
    if str == "user_credit"
      if loan_amount <= admin_wallet
        Admin.first.update(wallet_amount: admin_wallet - loan_amount)
        current_user.update(wallet_amount: user_wallet + loan_amount)
        return true
      else
        return false
      end
    elsif str == "user_debit"
      if loan_amount > user_wallet
        current_user.update(wallet_amount: 0)
        Admin.first.update(wallet_amount: admin_wallet + user_wallet)
      else
        final_amount = loan_amount + (loan.interest_rate / 100 * loan_amount)
        current_user.update(wallet_amount: user_wallet - final_amount)
        Admin.first.update(wallet_amount: admin_wallet + final_amount)
      end
    end
  end
end
