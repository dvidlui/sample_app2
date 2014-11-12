class Micropost
	include Mongoid::Document
	include Mongoid::Timestamps
	
	belongs_to 	:user, index: true
	
  field :content, 					type: String
	field :picture,						type: String
	
	index({ user_id: 1, created_at: 1 })
	
	default_scope -> {order_by(:created_at => :desc)}
	# scope :recent, ->{order_by(:created_at => :desc)}
	mount_uploader :picture, PictureUploader
	validates :user_id, presence: true
	validates :content, presence: true, length: { maximum: 140 }
	validate  :picture_size

	# Returns microposts from the users being followed by the given user
	def Micropost.from_users_followed_by(user)
		following_ids = user.following
		any_of({user_id: user._id}, {:user_id.in => following_ids})
	end
	
	private
		def picture_size
			if picture.size > 5.megabytes
				errors.add(:pciture, "should be less than 5MB")
			end
		end
end
