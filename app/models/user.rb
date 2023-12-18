class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :loans

  after_initialize :set_custom_field, if: :new_record?

  def debit_wallet(amount)
    update!(wallet_amount: wallet_amount - amount)
  end

  private

  def set_custom_field
    self.wallet_amount ||= 10000
  end
end
