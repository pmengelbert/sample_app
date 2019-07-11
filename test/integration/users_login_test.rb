require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  # retrieve the user michael from test/fixtures/users.yml
  def setup
    @sample_user = users(:michael)
  end

  test "flash messages should be correct" do
    get login_path #1
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "foo@bar",
                               password: "aaa" } }
    assert_template 'sessions/new' 
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    # visit the login page
    get login_path
    
    # post the valid credentials
    post login_path, params: { session: { email: @sample_user.email,
                                          password: 'password' } }

    # are we logged in?
    assert is_logged_in?

    # ensure we've been redirected to the user page
    assert_redirected_to @sample_user
    # and actually carry out the redirect
    follow_redirect!

    # make sure the page we land on has the right template
    assert_template 'users/show'

    # make sure the 'Log in' link has disappeared, 
    # and been replaced with logout and profile
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@sample_user)
    assert_select "a[href=?]", list_path

    # send a DELETE request to the logout path
    delete logout_path

    # double check that nobody is logged in
    assert_not is_logged_in?

    # were we taken back to the root url?
    assert_redirected_to root_url
    follow_redirect!

    # make sure the Log In link has returned to the header, and the logout and User list has disappeared
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@sample_user), count: 0
    assert_select "a[href=?]", list_path, count: 0
  end
end
