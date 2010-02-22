class UserMailer < ActionMailer::Base
  require 'mms2r'
  require 'tmail'
  
  def receive(email)
    mms = MMS2R::Media.new(email)
    e = Email.new(:from => mms.from.first,
                  :to => mms.to.first,
                  :subject => mms.subject,
                  :body => mms.body)
    
    logger.info "Default media path: #{mms.default_media.path}"
    
    logger.info "Media"
    mms.media.each do |key, value|
      logger.info "#{key} => #{value}"
    end
    
    logger.info "Process"
    mms.process do |media_type, file|
      logger.info "#{media_type} => #{file}"
    end
    
    unless mms.media['application/octet-stream'].blank?
      mms.media['application/octet-stream'].each do |f|
        logger.info "Octet-stream #{f}"
      end
    end
    
    
    #mms.purge
    
    # logger.info "application/xml"
    #   unless mms.media['application/xml'].blank?
    #     mms.media['application/xml'].each do |f|
    #     e.attachment = File.open(f)
    #     logger.info "Filename: #{e.attachment}"
    #     logger.info "#{f}"
    #   end
    # end
    
    
    
    # logger.info "TMail attachment"
    #     if email.has_attachments?
    #       logger.info "has_attachments!"
    #       email.attachments.each do |attachment|
    #         e.attachment = attachment
    #         logger.info "#{attachment.original_filename}"
    #       end
    #     end
    e
  end
  
end
