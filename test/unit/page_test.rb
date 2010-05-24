require 'test_helper'

class PageTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert_equal false, Page.new().valid?
  end
end
