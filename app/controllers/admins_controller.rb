# app/controllers/admins_controller.rb
class AdminsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @admin = current_admin
    @active_loans = Loan.where(state: 'open')
    @repaid_loans = Loan.where(state: 'closed')
  end

  def show
    @admin = current_admin
  end

  def loan_request
    @loan_requests = Loan.where(state: "requested")
  end

  def approve_loan
    @loan = Loan.find(params[:id])
    @loan.interest_rate = params[:interest_rate] if params[:interest_rate].present?
    @loan.update(interest_rate: @loan.interest_rate)
    if @loan.approve!
      flash.now[:notice] = 'Loan approved successfully.'
      redirect_to admin_path
    else
      flash.now[:alert] = 'Failed to approve the loan.'
      render :loan_requests
    end
  end

  def reject_loan
    @loan = Loan.find(params[:id])
    if @loan.reject_by_admin!
      flash.now[:notice] = 'Loan rejected successfully.'
      redirect_to admin_path
    else
      flash.now[:alert] = 'Failed to approve the loan.'
      render :loan_requests
    end
  end

  def active_loan
    @active_loans = Loan.where(state: "open")
  end

  def rejected_loan
    @active_loans = Loan.where(state: "rejected")
  end

  def repaid_loan
    @repaid_loans = Loan.where(state: "closed")
  end
end
