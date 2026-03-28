require "test_helper"

class ReadingProgressTest < ActiveSupport::TestCase
  test "valid reading progress" do
    rp = users(:scholar).reading_progresses.build(passage: passages(:genesis_one_one), read_at: Time.current)
    assert rp.valid?
  end

  test "requires read_at" do
    rp = users(:scholar).reading_progresses.build(passage: passages(:genesis_one_one), read_at: nil)
    assert_not rp.valid?
  end

  test "unique passage per user" do
    users(:scholar).reading_progresses.create!(passage: passages(:genesis_one_one), read_at: Time.current)
    dup = users(:scholar).reading_progresses.build(passage: passages(:genesis_one_one), read_at: Time.current)
    assert_not dup.valid?
  end
end
