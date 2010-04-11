require 'test_helper'

class MenuNodeTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert MenuNode.new.valid?
  end
end
