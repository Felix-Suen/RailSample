require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:felix)
  end

  test "unsuccessful edit" do
    get edit_user_path(@user)
    patch user_path(@user), params: { user: { name: "", email: "user@invalid",
      password: "food", password_confirmation: "skoom" } }
    assert_template 'users/edit'
  end

  test 'successful edits' do
    get edit_user_path(@user)
    patch user_path(@user), params: { user: { name: "example",
      email: "example@valid.com", password: "",
      password_confirmation: ""} }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, "example"
    assert_equal @user.email, "example@valid.com"
  end

end
