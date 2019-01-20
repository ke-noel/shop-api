class Product < ApplicationRecord
	validates_presence_of :title
	validates :price, :inventory_count, numericality: { greater_than_or_equal_to: 0 }, presence: true
end
