# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @loans = @user.loans
  end

  def show
    @user = current_user
    @loans = @user.loans.order(created_at: :desc)
    @wallet_balance = @user.wallet_amount
  end

  def loan_request
    @loan_requests = current_user.loans.approved
  end

  def create_loan_request
    @loan = current_user.loans.new(state: 'requested', admin_id: Admin.first.id, amount: params[:amount])
    if @loan.save!
      flash.now[:notice] = 'Loan request sent successfully.'
      redirect_to user_path
    else
      flash.now[:alert] = 'Failed to send loan request.'
      render :loan_requests
    end
  end

  def confirm_interest_rate
    @loan = current_user.loans.find(params[:id])
    loan_allow = wallet_logic("user_credit", @loan.id)
    if loan_allow && @loan.confirm!
      flash.now[:notice] = 'Interest rate confirmed successfully.'
    else
      flash.now[:alert] = 'Failed to confirm interest rate.'
    end
    redirect_to user_path
  end

  def reject_interest_rate
    @loan = current_user.loans.find(params[:id])

    if @loan.reject_by_user!
      flash[:notice] = 'Interest rate rejected successfully.'
    else
      flash[:alert] = 'Failed to reject interest rate.'
    end

    redirect_to user_path
  end

  def repay_loan_form
    @loans = current_user.loans.open
  end

  def repay_loan
    @loan = current_user.loans.find(params[:loan_id])
    wallet_logic("user_debit", @loan.id)

    if @loan.repay!
      flash.now[:notice] = 'Loan repaid successfully.'
      redirect_to user_path
    else
      flash.now[:alert] = 'Failed to repay the loan.'
    end
  end

  def loan_detail
    @loan = current_user.loans.find(params[:id])
  end
end