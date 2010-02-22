class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  named_scope :approved, :conditions => {:approved => true}
  
  validates_presence_of :content
  
  attr_accessible :content, :user_id, :commentable_id, :commentable_type
  
  # Finds the commentable thats not a comment
  def non_comment_parent
    find_non_comment_parent(self)
  end
  
  private
  
  def find_non_comment_parent(comment)
    if comment.commentable.class.to_s != "Comment"
      return comment.commentable
    else
      find_non_comment_parent(comment.commentable)
    end
  end
  
end
