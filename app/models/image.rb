class Image < ActiveRecord::Base
  attr_reader :image
  
  before_destroy :delete_dir
  after_update :delete_dir
            
  def image=(image)
    new_image = MiniMagick::Image.new(image.path)
    self.file_name = image.original_filename.sanitize
    self.file_type = image.content_type
    self.file_size = image.size
    self.height = new_image[:height]
    self.width = new_image[:width]
    self.file_content = new_image.to_blob
  end
  
  IMAGE_SIZES = {:original => nil, :medium => "480x480>", :small => "218x218>", :thumbnail => "100x100>"}
  
  def original
    original = MiniMagick::Image.read(self.file_content.to_s)
    image_processing(original, "original").to_blob
  end
  
  def medium
    medium = MiniMagick::Image.read(self.file_content.to_s)
    image_processing(medium, "medium").to_blob
  end
  
  def small
    small = MiniMagick::Image.read(self.file_content.to_s)
    image_processing(small, "small").to_blob
  end
  
  def thumbnail
    thumbnail = MiniMagick::Image.read(self.file_content.to_s)
    image_processing(thumbnail, "thumbnail").to_blob
  end
  
  private
  
  def image_processing(image, size)
    image.resize IMAGE_SIZES[size.to_sym] unless IMAGE_SIZES[size.to_sym] == nil
    path = "#{RAILS_ROOT}#{APP_CONFIG['image_path']}/#{self.id}"
    FileUtils.mkdir_p(path) unless File.directory?(path)
    File.open("#{path}/#{size}.#{self.file_name}", 'w') {|f| f.write(image.to_blob) }
    image
  end
  
  def delete_dir
    FileUtils.rm_rf "#{RAILS_ROOT}#{APP_CONFIG['image_path']}/#{self.id}"
  end
end
