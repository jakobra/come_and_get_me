require 'test_helper'

class SideModuleTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert SideModule.new.valid?
  end
end
