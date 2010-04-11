class MenuNode < ActiveRecord::Base
  has_many :menu_node_side_modules
  has_many :side_modules, :through => :menu_node_side_modules
  acts_as_tree :order => :position
  
  accepts_nested_attributes_for :menu_node_side_modules, :allow_destroy => true
  
  attr_accessible :title, :url, :position, :parent_id, :viewable, :side_module_regex, :menu_node_side_modules_attributes
end
