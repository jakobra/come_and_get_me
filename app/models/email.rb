class Email < ActiveRecord::Base
  require 'tmail'
  
  has_attached_file :attachment,
                    :url => "/assets/:class/:id_:basename.:extension",
                    :path => ":rails_root/public/assets/:class/:id_:basename.:extension"
  
  def self.new_email_from_mail(email = nil)
    email = UserMailer.receive(email)
    email
  end
  
end
