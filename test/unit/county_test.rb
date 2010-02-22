require 'test_helper'

class CountyTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert County.new.valid?
  end
end
