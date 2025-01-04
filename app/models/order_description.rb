class OrderDescription < ApplicationRecord
  belongs_to :order
  belongs_to :item

  validates :order_id, :item_id, :quantity, :price, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
