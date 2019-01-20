class AuthenticateUser
	prepend SimpleCommand
	attr_accessor :name, :password

	def initialize(name, password)
		@name = name
		@password = password
	end

	def call
		JsonWebToken.encode(user_id: user.id) if user
	end

	private

	def user
		user = User.find_by_name(name)
		return user if user && user.authenticate(password)

		errors.add :user_authentication, 'Invalid credentials'
		nil
	end
end