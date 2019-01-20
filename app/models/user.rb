class User < ApplicationRecord
	validates_presence_of :password_digest
	validates :name, uniqueness: true, presence: true
	# todo must force to be unique

	# encrypt the password
	has_secure_password
end