class Order < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :email, presence: true
  validates :address, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  attribute :quantity, :integer, default: 1

  class QuantityMustBeAvailable < ActiveModel::Validator
    def validate(record)
      if record.product.present? && record.quantity.present? && record.quantity > 0
        if record.quantity > record.product.quantity_remaining
          record.errors.add(:quantity,"is more than what is in stock")
        end
      end
    end
  end

  validates_with QuantityMustBeAvailable
end
