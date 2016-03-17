class Topic < ActiveRecord::Base
	has_many :pt_relationships
	has_many :microposts, through: :pt_relationships

	validates :name, presence: true, length: { maximum: 255 }, format: { with: /\A[a-zA-Z0-9 ]+\z/ }
end
