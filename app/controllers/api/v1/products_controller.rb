module Api
	module V1
		class ProductsController < ApplicationController
			before_action :set_product, only: [:show]
			# Before any action, authenticate_request is called

			# GET api/v1/products
			def index
				# to return in stock or out of stock: /products?in_stock=[BOOLEAN]
				if params[:in_stock] == "true"
					@products = Product.where("inventory_count > '0'")
				elsif params[:in_stock] == "false"
					@products = Product.where("inventory_count == '0'")
				else
					@products = Product.all
				end
				render json: { message: @products }, status: :ok
			end

			# GET api/v1/products/:id
			def show
				render json: { message: @product }, status: :ok
			end

			# Purchase product if in stock
			# GET api/v1/products/:id/purchase
			def purchase
				@product = Product.find(params[:product_id])
				current_inventory = @product[:inventory_count]

				if current_inventory > 0
					@product.update(:inventory_count => (current_inventory - 1))
					message = "#{@product[:title]} has been purchased for $#{@product[:price]}. There are #{@product[:inventory_count]} left in stock."
				else
					message = "Item not purchased. #{@product[:title]} is out of stock."
				end
				render json: { message: message }, status: :ok
			end

			private

			def set_product
				@product = Product.find(params[:id])
			end
		end
	end
end