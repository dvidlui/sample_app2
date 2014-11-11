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
	
	private
		def picture_size
			if picture.size > 5.megabytes
				errors.add(:pciture, "should be less than 5MB")
			end
		end
end
