require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:felix)
  end

  test "unsuccessful edit" do
    post login_path, params: { session: { email: @user.email,
                                          password: 'password',
                                          remember_me: '1' } }
    get edit_user_path(@user)
    patch user_path(@user), params: { user: { name: "", email: "user@invalid",
      password: "food", password_confirmation: "skoom" } }
    assert_template 'users/edit'
  end

  test 'successful edits' do
    post login_path, params: { session: { email: @user.email,
                                          password: 'password',
                                          remember_me: '1' } }
    patch user_path(@user), params: { user: { name: "example",
      email: "example@valid.com", password: "",
      password_confirmation: ""} }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, "example"
    assert_equal @user.email, "example@valid.com"
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    post login_path, params: { session: { email: @user.email,
                                          password: 'password',
                                          remember_me: '1' } }
    assert_redirected_to edit_user_url(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
      email: email,
      password: "",
      password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

end
