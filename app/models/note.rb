class Note < ActiveRecord::Base
  belongs_to :notetable, :polymorphic => true
  attr_accessible :content, :noteable_id, :noteable_type
end
