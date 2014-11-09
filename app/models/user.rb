class User
	attr_accessor	:remember_token
  include ActiveModel::SecurePassword
  include Mongoid::Document
  before_save { self.email = email.downcase }
  field :name,              type: String
  field :email,             type: String
  field :created_at,        type: Date
  field :updated_at,        type: Date
  field :password_digest,   type: String
	field :remember_digest,		type: String
	field :admin,							type: Boolean
  has_secure_password
  
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: true
                      
  index({ email: 1 }, { unique: true, name: "users_email_index" })
  validates :password, length: { minimum: 6 }
	
	# Returns the hash digest of the given string
	def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
	end
	
	# Returns a random token.
	def User.new_token
		SecureRandom.urlsafe_base64
	end
	
	# Remembers a user in the database for use in persistent sessions.
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end
	
	# Returns true if the given token matches the digest.
	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end
	
	# Forgets a user.
	def forget
		update_attribute(:remember_digest, nil)
	end
end
