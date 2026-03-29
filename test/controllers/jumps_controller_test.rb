require "test_helper"

class JumpsControllerTest < ActionDispatch::IntegrationTest
  test "show resolves valid reference" do
    get jump_path(ref: "Genesis 1:1")
    assert_redirected_to reading_path(corpus_slug: "bible", scripture_slug: "genesis", division_number: 1)
  end

  test "show redirects back for invalid reference" do
    get jump_path(ref: "Nonexistent 99:99")
    assert_redirected_to root_path
  end

  test "show handles partial book name" do
    get jump_path(ref: "Gen 1:1")
    assert_redirected_to reading_path(corpus_slug: "bible", scripture_slug: "genesis", division_number: 1)
  end
end
