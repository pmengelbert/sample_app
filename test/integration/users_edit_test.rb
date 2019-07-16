require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    # assign the @user variable (accessible to this test) to the user :michael defined in the
    # test/fixtures/users.yml file.  The method users() gets its name from that file.
    @user = users(:michael)
  end

  test "unsucessful edit" do
    # log in, to satisfy the before filters of the Users controller
    log_in_as(@user)
    # visit this user's edit path. i.e. if this is uer 1, /users/1/edit
    get edit_user_path(@user)
    assert_template 'users/edit'
    # send a PATCH request with the following invalid data
    patch user_path(@user), params: { user: { name: "",
                                             email: "foo@invalid",
                                             password: "foo",
                                             password_confirmation: "bar" } }
    # make sure we're redirected to the edit page
    assert_template 'users/edit'

    # make sure there are 4 error messages
    assert_select "div.alert", text: "The form contains 4 errors."
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    # log in, to satisfy the before filters of the Users controller
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    assert_nil session[:forwarding_url]
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

end
