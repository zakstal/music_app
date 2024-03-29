class User < ActiveRecord::Base
	attr_reader :password

	validates :password_digest, presense: true
	validates :password, length: { minimum: 6, allow_nil: true }
	validates :session_token, presence: true, uniqueness: true
	validates :username, presence: true, uniqueness: true

	after_initialize :ensure_session_token

	def self.find_by_credentails(username,password)
		user = User.find_by_username(username)
		return if user.nil?
		user.try(:is_password?) ? user : nil 
	end

	def self.generate_session_token
		SecureRandom::urlsafe_base64(16)
	end

	def is_passowrd?(unencrypted_password)
		BCrypt::Password.new(self.password_digest)
						.is_password?(unencrypted_password)
	end

	def password=(unencrypted_password)
		if unencrypted_password.present?
			@password = unencrypted_password
			self.password_digest = BCrypt::Password.create(unencrypted_password)
		end
	end

	def reset_session_token
		self.session_token = self.class.generate_session_token
		self.save!
		self.session_token
	end

	def ensure_session_token
		self.session_token ||= self.class.generate_session_token
	end

end