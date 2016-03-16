class Topic < ActiveRecord::Base
	has_many :pt_relationships
	has_many :microposts, through: :pt_relationships
end
