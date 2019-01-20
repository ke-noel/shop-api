class JsonWebToken
	class << self
		def encode(payload, exp = 2.hours.from_now)
			# set token expiration time
			payload[:exp] = exp.to_i
			# encode user data (payload) using secret key
			JWT.encode(payload, Rails.application.credentials.secret_key_base)
		end

		def decode(token)
			# decode token to return user data
			body = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
			HashWithIndifferentAccess.new body

			# raise custom error to be handled by custom handler
		rescue JWT::ExpiredSignature, JWT::VerificationError => e
			raise ExceptionHandler::ExpiredSignature, e.message
		rescue JWT::DecodeError, JWT::VerificationError => e
			raise ExceptionHandler::DecodeError, e.message
		end
	end
end