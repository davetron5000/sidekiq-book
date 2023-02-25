class Product < ApplicationRecord
  def self.available = self.where("quantity_remaining > 0")
end
