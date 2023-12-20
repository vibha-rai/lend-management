# app/controllers/loans_controller.rb
class LoansController < ApplicationController

  def index
    @loans = Loan.all
  end

  def show
    @loan = Loan.find(params[:id])
  end

  def new
    @loan = Loan.new
  end

  def create
    @user = current_user
    @loan = @user.loans.new(loan_params.merge(state: 'requested'))

    if @loan.save
      flash[:notice] = 'Loan request sent successfully.'
      redirect_to users_path
    else
      flash[:alert] = 'Failed to send loan request.'
      render :new
    end
  end

  def edit
    @loan = Loan.find(params[:id])
  end

  def update
    @loan = Loan.find(params[:id])

    if @loan.update(loan_params)
      flash[:notice] = 'Loan updated successfully.'
      redirect_to loan_path(@loan)
    else
      flash[:alert] = 'Failed to update loan.'
      render :edit
    end
  end

  def destroy
    @loan = Loan.find(params[:id])

    if @loan.destroy
      flash[:notice] = 'Loan deleted successfully.'
    else
      flash[:alert] = 'Failed to delete loan.'
    end

    redirect_to loans_path
  end

  # Add other actions as needed

  private

  def loan_params
    params.require(:loan).permit(:amount, :interest_rate)
  end
end
