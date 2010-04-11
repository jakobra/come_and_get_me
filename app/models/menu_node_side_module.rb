class MenuNodeSideModule < ActiveRecord::Base
  belongs_to :side_module
  named_scope :left, :conditions => {:position => false}
  named_scope :right, :conditions => {:position => true}
  
  named_scope :left_before, :conditions => {:position => false, :position_y => false}
  named_scope :right_before, :conditions => {:position => true, :position_y => false}
  
  named_scope :left_after, :conditions => {:position => false, :position_y => true}
  named_scope :right_after, :conditions => {:position => true, :position_y => true}
end
