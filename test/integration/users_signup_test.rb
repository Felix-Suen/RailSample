require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup" do
    get signup_path
    assert_no_difference 'User.count' do
      before_count = User.count
      post users_path, params: { user: { name: "", email: "user@invalid",
        password: "food", password_confirmation: "skoom"} }
    end
    assert_template "users/new"
  end

  test "valid signup" do
    get signup_path
    assert_difference 'User.count' do
      before_count = User.count
      post users_path, params: { user: { name: "example",
        email: "example@valid.com", password: "skooma",
        password_confirmation: "skooma"} }
    end
    follow_redirect!
    assert_template "users/show"
  end
end
