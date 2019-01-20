# Generate default data for products
# This can be loaded with rails db:seed or rails db:setup

200.times do
	Product.create({
		title: Faker::Book.unique.title,
		price: get_random_price(5, 30)
		inventory_count: rand(15)
	})
end

def get_random_price(min, max)
	return (rand * (max-min) + min).round(2)