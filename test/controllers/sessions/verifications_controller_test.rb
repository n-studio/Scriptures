require "test_helper"

class Sessions::VerificationsControllerTest < ActionDispatch::IntegrationTest
  test "show renders verification form" do
    get session_verification_path
    assert_response :success
    assert_select "h1", /Check your email/
  end

  test "create signs in with valid code" do
    token = magic_tokens(:valid_token)
    cookies[:browser_token] = create_signed_cookie(:browser_token, token.browser_token)
    post session_verification_path, params: { code: token.short_code }
    assert_redirected_to root_path
    assert cookies[:session_id].present?
  end

  test "create rejects wrong browser token" do
    token = magic_tokens(:valid_token)
    cookies[:browser_token] = create_signed_cookie(:browser_token, "wrong")
    post session_verification_path, params: { code: token.short_code }
    assert_redirected_to session_verification_path
  end

  test "create rejects missing browser token" do
    token = magic_tokens(:valid_token)
    post session_verification_path, params: { code: token.short_code }
    assert_redirected_to new_session_path
  end

  private

  def create_signed_cookie(name, value)
    ActionDispatch::TestRequest.create.cookie_jar.tap do |jar|
      jar.signed[name] = value
    end[name]
  end
end
