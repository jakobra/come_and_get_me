class Image < ActiveRecord::Base
  has_attached_file :image,
                    :styles => { :thumb => "100x100>", :xsmall => "218x218>", :small => "480x480>" },
                    :url => "/assets/images/:id/:style_:basename.:extension",
                    :path => ":rails_root/public/assets/images/:id/:style_:basename.:extension"
end
