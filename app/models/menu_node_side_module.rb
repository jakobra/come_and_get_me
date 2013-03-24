class MenuNodeSideModule < ActiveRecord::Base
  attr_accessible :side_module_id, :position, :position_y
  
  belongs_to :side_module
  scope :published, where(:publish => true).order("created_at DESC")
  scope :left, where(:position => false)
  scope :right, where(:position => true)
  
  scope :left_before, where(:position => false, :position_y => false)
  scope :right_before, where(:position => true, :position_y => false)
  
  scope :left_after, where(:position => false, :position_y => true)
  scope :right_after, where(:position => true, :position_y => true)
end
