class PtRelationship < ActiveRecord::Base
  belongs_to :micropost
  belongs_to :topic
end
