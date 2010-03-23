class NotificationMailer < ActionMailer::Base
  
  def report_comment(comment_id)
    recipients "jakob@jakobra.com"
    from      "comment_report@comeandgetme.se"
    subject   "Comment with id '#{comment_id}' has been reported"
  end

end
