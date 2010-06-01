class CommentsController < ApplicationController
  filter_resource_access
  
  def index
    @comments = Comment.all
  end
  
  def new
    @commentable = find_commentable
    @comment = @commentable.comments.build
  end
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    @comment.user_id = current_user.id
    
    @comment.save
  end
  
  def update
    @comment = Comment.find(params[:id])
    
    @comment.update_attributes(params[:comment])
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    
    flash[:notice] = "Successfully destroyed comment."
    redirect_to comments_url
  end
  
  def approve
    @comment = Comment.find(params[:id])
    @comment.toggle!(:approved)
    flash[:notice] = "Successfully Approved/Unapproved comment."
    redirect_to comments_url
  end
  
  def report
    NotificationMailer.deliver_report_comment(params[:id])
    logger.info "Comment with id = #{params[:id]} has been reported"
  end
  
  private
  
  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
  
end
