require 'test_helper'

class CountyTest < ActiveSupport::TestCase
  def test_should_be_valid_with_attributes
    assert_equal true, County.new(:name => "Stockholm", :code => "ab", :numeric_code => 5).valid?
  end
  
  def test_should_be_invalid_without_attributes
    assert_equal false, County.new().valid?
  end
end
