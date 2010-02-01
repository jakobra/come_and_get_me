class UserMailer < ActionMailer::Base
  require 'mms2r'
  
  def receive(email)
    mms = MMS2R::Media.new(email)
    e = Email.new(:from => mms.from.first,
                  :to => mms.to.first,
                  :subject => mms.subject,
                  :body => mms.body)
                  
    if email.has_attachments?
      email.attachments.each do |attachment|
        e.attachment = attachment
      end
    end
    e
  end
  
end
