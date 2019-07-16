require 'test_helper'

class UsersNavigateTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "not logged in users should get the proper layout" do
    get root_path
    # make sure the logged-in navigation links are correct
    assert_select "a[href=?]", user_path(@user), count: 0
    assert_select "a[href=?]", edit_user_path(@user), count: 0
    assert_select "a[href=?]", logout_path, count: 0

    # try to visit the users index before logging in
    get users_path
    assert_redirected_to login_path


    # try to visit the user edit path
    get edit_user_path(@user)
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
  end


end
