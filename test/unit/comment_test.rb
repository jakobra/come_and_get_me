require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert_equal false, Comment.new.valid?
  end
end
