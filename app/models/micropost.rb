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
  validate  :topics_provided

  after_save :add_topics_to_post
  
  private

    # Validates the topics provided. Validation is definded in topics model.
    def topics_provided
      is_valid = true
      topics_arr = get_topics_arr
      topics_arr.each{|topic_name|
        topic = Topic.where(name: topic_name).first_or_initialize
        unless topic.save
          is_valid = false
          break
        end
      }
      errors.add(:topic, "should not contain special characters and should be less than 255 characters") unless is_valid
    end

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

    # Saves topics for a post.
    def add_topics_to_post
      topics_arr = get_topics_arr
      topics_arr.each{|topic_name|
        # topic = Topic.where(name: topic_name).first_or_initialize
        # topic.save
        topic = Topic.find_by(name: topic_name)
        pt_relationship = PtRelationship.create(micropost_id: id, topic_id: topic.id)
      }
    end

    def get_topics_arr
      topic_list.split(",").reject{|t| t.to_s.empty?}.map{|t| t.strip}
    end
end
