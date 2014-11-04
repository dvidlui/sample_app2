class User
  include ActiveModel::SecurePassword
  include Mongoid::Document
  before_save { self.email = email.downcase }
  field :name,              type: String
  field :email,             type: String
  field :created_at,        type: Date
  field :updated_at,        type: Date
  field :password_digest,   type: String
  has_secure_password
  
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: true
                      
  index({ email: 1 }, { unique: true, name: "users_email_index" })
  validates :password, length: { minimum: 6 }
end
