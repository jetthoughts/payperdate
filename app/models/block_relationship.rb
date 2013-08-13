class BlockRelationship < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, class_name: 'User'
end
