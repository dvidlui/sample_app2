class Relationship
  include Mongoid::Document
	include Mongoid::Timestamps
	
	belongs_to :follower, class_name: "User", inverse_of: :active_relationships
	belongs_to :followed, class_name: "User", inverse_of: :passive_relationships
	
  field :follower_id, type: String
  field :followed_id, type: String
	
	index({ follower_id: 1 })
	index({ followed_id: 1 })
	index({ follower_id: 1, followed_id: 1 }, { unique: true})
	
	validates :follower_id, presence: true
	validates :followed_id, presence: true
end
