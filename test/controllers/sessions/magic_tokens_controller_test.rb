require "test_helper"

class Sessions::MagicTokensControllerTest < ActionDispatch::IntegrationTest
  test "show signs in with valid token" do
    token = magic_tokens(:valid_token)
    get session_magic_token_path(token: token.token)
    assert_redirected_to root_path
    assert cookies[:session_id].present?
  end

  test "show rejects expired token" do
    token = magic_tokens(:expired_token)
    get session_magic_token_path(token: token.token)
    assert_redirected_to new_session_path
  end

  test "show rejects invalid token" do
    get session_magic_token_path(token: "bogus")
    assert_redirected_to new_session_path
  end
end
