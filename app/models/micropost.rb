class Micropost < ActiveRecord::Base
  attr_accessor :topic_list
  has_many :pt_relationships
  has_many :topics, :through => :pt_relationships
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  after_save :save_topics
  
  private
  
    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

    # Saves topics for a post.
    def save_topics
      topics_arr = topic_list.split(",").reject{|t| t.to_s.empty?}
      topics_arr.each{|topic_name|
        topic = Topic.where(name: topic_name).first_or_initialize
        topic.save
        
        pt_relationship = PtRelationship.create(micropost_id: id, topic_id: topic.id)
      }
    end
end
