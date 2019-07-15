require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    # assign the @user variable (accessible to this test) to the user :michael defined in the
    # test/fixtures/users.yml file.  The method users() gets its name from that file.
    @user = users(:michael)
  end

  test "unsucessful edit" do
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
  end
end
