require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,      "Peter's Webpage"
    assert_equal full_title("Help"),      "Help | Peter's Webpage"
  end
end
