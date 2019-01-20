class UsersController < ApplicationController
	skip_before_action :authenticate_request, only: [:login, :register]
	
	# POST auth/register
	def register
		@user = User.create(user_params)
		if @user.save
			render json: { message: "User created successfully." }, status: :created
		else
			render json: { message: @user.errors }, status: :bad
		end
	end

	# POST auth/login
	def login
		authenticate params[:name], params[:password]
	end

	def test
		render json: { message: "You're in!", status: :ok }
	end

	private

	def authenticate(name, password)
		command = AuthenticateUser.call(name, password)

		if command.success?
			render json: { access_token: command.result, message: "Login successful!" }, status: :ok
		else
			render json: { error: command.errors }, status: :unauthorized
		end
	end

	def user_params
		params.permit(:name, :password)
	end
end